// 1. IDEMPOTENCY: Prevent double-sending
if (draft.hasTag("captured")) {
  alert("HALTED: This draft already has the 'captured' tag.");
  context.cancel();
} else {

  // 2. CONFIGURATION
  const folderPath = "3-resources/periodic/"; // MUST match your folder exactly!
  const dateFormat = "%Y-%m-%d"; 

  // 3. PARSE THE DRAFT & APPLY YOUR ROUTING RULES
  const text = draft.content.trim();
  const lines = text.split('\n');
  const firstLine = lines[0];
  const body = lines.slice(1).join('\n');

  const taskRegex = /^- \[[ x]\] /i;     
  const plannerRegex = /^- \d{1,2}:\d{2}/; 

  let targetHeading = "";
  let textToAdd = "";

  if (taskRegex.test(firstLine)) {
      targetHeading = "Tasks";
      textToAdd = firstLine + (body ? "\n" + body : "");
  } else if (plannerRegex.test(firstLine)) {
      targetHeading = "Day Planner";
      textToAdd = text; 
  } else {
      targetHeading = "Notes";
      textToAdd = "### " + firstLine + (body ? "\n" + body : "");
  }

  // 4. THE FILE MANAGER MAGIC
  let bookmark = Bookmark.findOrCreate("ObsidianLocalVault");
  let fm = FileManager.createForBookmark(bookmark);
  
  let dailyNoteFileName = folderPath + draft.processTemplate("[[date|" + dateFormat + "]]") + ".md";

  if (!fm.exists(dailyNoteFileName)) {
      alert("FILE NOT FOUND ERROR: Drafts is looking for a file at:\n" + dailyNoteFileName + "\n\nBut it doesn't exist in the folder you selected.");
      context.fail();
  } else {
      let content = fm.readString(dailyNoteFileName);
      let fileLines = content.split('\n');
      let headerIndex = -1;
      let nextHeaderIndex = -1;

      // Find your target heading
      let headerRegex = new RegExp('^#+\\s' + targetHeading + '\\s*$');
      for (let i = 0; i < fileLines.length; i++) {
          if (headerRegex.test(fileLines[i])) {
              headerIndex = i;
              break;
          }
      }

      if (headerIndex === -1) {
          alert("HEADING ERROR: Drafts opened the file, but could not find the exact heading: " + targetHeading);
          context.fail();
      } else {
          // Find the next heading in the document so we can insert BEFORE it
          for (let i = headerIndex + 1; i < fileLines.length; i++) {
              if (/^#+\s/.test(fileLines[i])) {
                  nextHeaderIndex = i;
                  break;
              }
          }

          textToAdd = "\n" + textToAdd;

          if (nextHeaderIndex === -1) {
              fileLines.push(textToAdd);
          } else {
              fileLines.splice(nextHeaderIndex, 0, textToAdd + "\n");
          }

          let newContent = fileLines.join('\n');
          
          if (fm.writeString(dailyNoteFileName, newContent)) {
              draft.addTag("captured");
              draft.update();
              app.displaySuccessMessage("Appended to " + targetHeading);
          } else {
              alert("WRITE ERROR: Drafts found the file and heading, but iOS blocked it from saving.");
              context.fail();
          }
      }
  }
}