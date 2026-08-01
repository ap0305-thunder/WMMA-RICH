projectRoot = ParentDirectory[DirectoryName[$InputFileName]];
loadResult = Quiet@Check[Get[FileNameJoin[{projectRoot, "src", "LoadProject.wl"}]], $Failed];
VerificationTest[loadResult =!= $Failed, True, TestID -> "project-loader-completes"]
VerificationTest[MemberQ[$Packages, "myNotebookInit`"], True, TestID -> "myNotebookInit-loaded"]
VerificationTest[MemberQ[$Packages, "base`"], True, TestID -> "base-loaded"]
