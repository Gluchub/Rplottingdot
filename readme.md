install R

1. open env variables 
system varaible 
click on path and edit it ,
click new variable and set R path
Search for "Path" and set it to the R executable location (e.g., C:/Program Files/R/R-x.x.x/bin/R.exe).

Open VS Code:

Launch Visual Studio Code.
Create a New File:

Click on File > New File or press Ctrl+N (Windows/Linux) or Cmd+N (Mac).
Set the File Type:

2. Save the file with an .R extension:
Click on File > Save As....
Choose a folder, type your file name, and add .R as the extension (e.g., new1.R).
This tells VS Code that it's an R file, enabling syntax highlighting and R-specific features.
Install and Activate R Extension (if not done earlier):

3. Install the R Extension.
Once installed, the extension activates whenever an .R file is opened.

4. Install dependencies important step :
click ctrl+shift+p
type create R terminal

install.packages(c("ggplot2", "shiny", "readxl", "shinythemes"))

5. Run the Shiny app:
click ctrl+shift+p
type create R terminal
source("new1.R")



