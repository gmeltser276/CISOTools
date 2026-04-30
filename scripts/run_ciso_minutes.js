// scripts/run_ciso_minutes.js
// Default: auto-detect newest .m4a; pass true from template to prompt for audio.
module.exports = async function (tp, promptAudio = false) {
  if (!tp) return "templater context (tp) is missing";

  // --- Resolve absolute OS path of the active note ---
  const base =
    (typeof tp.app?.vault?.adapter?.getBasePath === "function")
      ? tp.app.vault.adapter.getBasePath()
      : (tp.app?.vault?.adapter?.basePath || null);
  if (!base) return "vault base not found";

  let notePath = (tp.file && typeof tp.file.path === "function") ? tp.file.path() : null;
  if (!notePath) {
    const af = tp.app?.workspace?.getActiveFile?.();
    if (!af || !af.path) return "active note has no path (save the note before running)";
    notePath = af.path;
  }
  const note = notePath.startsWith("/") ? notePath : base + "/" + notePath;

  // --- Optional manual audio selection (otherwise helper auto-detects) ---
  let audio = "";
  if (promptAudio === true) {
    audio = await tp.system.prompt("Audio path (.m4a). Leave blank to auto-detect from Attachments:");
  }

  // --- Purge option for transcript ---
  const delChoice = await tp.system.suggester(
    ["Keep transcript .txt", "Delete transcript after insert"],
    ["no", "yes"],
    false,
    "Purge raw transcript?"
  );
  const delFlag = (delChoice === "yes") ? "-k" : "";

  // --- Helper path: CISO_MINUTES_HELPER env var, or $HOME/bin/ fallback ---
  const helper = process.env.CISO_MINUTES_HELPER
    || require("os").homedir() + "/bin/obsidian_fabric_minutes.sh";

  // --- Build args and execute ---
  const args = [];
  if (audio && audio.trim().length > 0) {
    args.push("-a", audio);
  }
  args.push("-n", note);
  if (delFlag) args.push(delFlag);

  const { promisify } = require("util");
  const { execFile } = require("child_process");
  const home = require("os").homedir();
  const fullPath = [
    `${home}/tools/whisperx-env/bin`,
    `${home}/go/bin`,
    "/opt/homebrew/bin",
    "/opt/homebrew/sbin",
    "/usr/local/bin",
    process.env.PATH || "/usr/bin:/bin:/usr/sbin:/sbin",
  ].join(":");
  const opts = {
    timeout: 0,
    env: { ...process.env, HOME: home, PATH: fullPath },
  };
  try {
    const { stdout } = await promisify(execFile)(helper, args, opts);
    return stdout.trim();
  } catch (err) {
    return `ERROR (exit ${err.code}): ${err.message}\nSTDOUT: ${err.stdout || "none"}\nSTDERR: ${err.stderr || "none"}`;
  }
};
