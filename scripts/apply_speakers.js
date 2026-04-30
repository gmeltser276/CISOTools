// scripts/apply_speakers.js
// Applies speaker name mappings from each Speakers table within MINUTES-BLOCK sections.
// Replacements are scoped to the transcript + minutes portion of each block only --
// the rest of the note is never touched.
//
// Usage: call from a Templater template: <% await tp.user.apply_speakers(tp) %>
//
// One-shot semantics: fill in all Name cells before running. Once [SPEAKER_00]
// is replaced with a real name, the original label is gone from that block.
module.exports = async function (tp) {
  if (!tp) return "";

  const af = tp.app.workspace.getActiveFile?.();
  if (!af) { new Notice("apply-speakers: no active file"); return ""; }

  const content = await tp.app.vault.read(af);

  // [^>]+? handles stems that contain spaces (e.g. "Recording 20260415164106")
  const BLOCK_RE =
    /<!-- MINUTES-BLOCK:([^>]+?) -->([\s\S]*?)<!-- \/MINUTES-BLOCK:\1 -->/g;

  let blocksProcessed = 0;
  let totalMappings = 0;
  let modified = content;

  modified = modified.replace(BLOCK_RE, (fullMatch, stem, blockContent) => {
    // Speakers table lives above ## Transcript; replacements apply below it
    const transcriptIdx = blockContent.indexOf("\n## Transcript");
    if (transcriptIdx === -1) return fullMatch;

    const headSection = blockContent.slice(0, transcriptIdx);
    let bodySection = blockContent.slice(transcriptIdx);

    // Parse table rows: | SPEAKER_XX | Display Name |
    // Skip header row where Name cell is literally "Name"
    const ROW_RE = /\|\s*(SPEAKER_\d+)\s*\|\s*([^|\n]+?)\s*\|/g;
    const mappings = new Map();
    let m;
    while ((m = ROW_RE.exec(headSection)) !== null) {
      const id = m[1].trim();
      // Strip any HTML artifacts Obsidian may insert (<br>, &nbsp;, etc.)
      const name = m[2].trim().replace(/<[^>]+>/g, "").trim();
      if (name !== id && name.toLowerCase() !== "name" && name.length > 0) {
        mappings.set(id, name);
      }
    }

    if (mappings.size === 0) return fullMatch;
    blocksProcessed++;
    totalMappings += mappings.size;

    for (const [id, name] of mappings) {
      // Replace bracketed form used in WhisperX txt output: [SPEAKER_00]
      bodySection = bodySection.replaceAll("[" + id + "]", "[" + name + "]");
      // Replace bare form that Fabric minutes may emit: word-boundary SPEAKER_00
      const esc = id.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      bodySection = bodySection.replace(new RegExp("\\b" + esc + "\\b", "g"), name);
    }

    return "<!-- MINUTES-BLOCK:" + stem + " -->" + headSection + bodySection + "<!-- /MINUTES-BLOCK:" + stem + " -->";
  });

  if (modified === content) {
    new Notice("apply-speakers: no name changes found in any Speakers table");
    return "";
  }

  await tp.app.vault.modify(af, modified);
  new Notice("apply-speakers: applied " + totalMappings + " mapping(s) across " + blocksProcessed + " block(s)");
  return "";
};
