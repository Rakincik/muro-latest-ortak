const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');

const searchStr = `<div className={\`bg-white border-l border-[#E2E8F0] flex flex-col shrink-0 transition-all duration-300 \${sidebarOpen ? 'w-full md:w-80' : 'w-0 overflow-hidden border-l-0'}\`}>`;
const replaceStr = `<div className={\`bg-white border-l border-[#E2E8F0] shrink-0 transition-all duration-300 md:relative \${sidebarOpen ? 'w-full md:w-80 flex flex-col md:block' : 'w-0 overflow-hidden border-l-0 hidden md:block'}\`}>\n                                <div className=\"md:absolute md:inset-0 flex flex-col w-full h-full\">`;

if (content.includes(searchStr)) {
    content = content.replace(searchStr, replaceStr);
    
    // Add the closing div
    const closeSearchStr = `                            </div>\r\n                        </div>\r\n                    </div>\r\n                );\r\n            })()}`;
    const closeReplaceStr = `                                </div>\r\n                            </div>\r\n                        </div>\r\n                    </div>\r\n                );\r\n            })()}`;
    
    // If CRLF search fails, try LF
    const closeSearchStrLF = `                            </div>\n                        </div>\n                    </div>\n                );\n            })()}`;
    const closeReplaceStrLF = `                                </div>\n                            </div>\n                        </div>\n                    </div>\n                );\n            })()}`;

    if (content.includes(closeSearchStr)) {
        content = content.replace(closeSearchStr, closeReplaceStr);
        fs.writeFileSync(filePath, content, 'utf8');
        console.log('SUCCESS CRLF');
    } else if (content.includes(closeSearchStrLF)) {
        content = content.replace(closeSearchStrLF, closeReplaceStrLF);
        fs.writeFileSync(filePath, content, 'utf8');
        console.log('SUCCESS LF');
    } else {
        console.log('FAILED TO FIND CLOSING DIVS');
    }
} else {
    console.log('FAILED TO FIND SEARCH STR');
}
