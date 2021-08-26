# CNIEL Website

The following website uses the Hugo Framework: (<https://gohugo.io/documentation/>). 

## Starting a server for testing

- Guide to installing hugo: (<https://gohugo.io/getting-started/installing/>)
- 'hugo server' is shows what the page looks like upon publication
- 'hugo server -D' displays all pages that are marked as draft
- 'hugo server --disableFastRender' is the go-to to see live-changes fast

## Important files

There are four main folders that are used.

- Archetypes
  - Files that specify the front-matter that is generated when 'hugo new' is used to create new content for specfic folders.
- Content
  - This is the main folder to work with for adding and editing content.
  - Contains markdown files holding information that will be used to automatically generate html pages.
  - To create a new page 'hugo new [filename]' must be used, otherwise page will not register with hugo.
    - Example: 'hugo new members/newMember.md'
- Layouts
  - Main folder to work with for editing how a page looks.  
  - Contains html layouts for individual and list pages.
  - All page-specfic css styles are in the their respective layout pages.
  - /_default folder
    - index.html is where you can edit the front page
    - /partials includes code blocks that can be inserted into html with {{partial "partialName" .}}
    - /_markup/render-image.html is used to ensure that all images in the content markup files are rendered correctly in html
  - /singles
    - Specifies the layouts for special one-off pages that need special layouts
    - To use a /singles layout, must define 'layout: layoutName' in markdown content file
    - An example of this is the contact page
- Static
  - Images, code, pdfs, and other linked files.
  - Global css styles are here as well in css/style.css

## Adding pages

Adding pages is as simple as creating a new file and filling in the information. Example of adding a new research page:

- 'hugo new research/researchName.md'
- Fill in frontmatter
- Body of text and images go in the md body
- Pages are sorted in lists by manually changed publish/edit date (this can be used to sort members and research pages)
## Miscellaneous Notes

- Filling in an the 'externalLink' field in research will specify it as an external research page
  - This page will not appear in the navbar
  - You only need to fill in title and shortDescription for the list page display
- Any links on the members page will be automatically converted into link-buttons
  - To keep the format consistent, please only link resumes/portfolios/emails here
  - The automatic formatting can be changed in /css/style.css
- For single pages, images are centered, justified, and inline by default
  - Can be changed in /layout/_default/single.html
- The width break that changes everything to mobile is at 768px
- The site can be previewed with github-pages with minimal set-up
  - (<https://gohugo.io/hosting-and-deployment/hosting-on-github/>)
