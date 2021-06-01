# CNI_Lab

## Hugo
The following website uses the Hugo Framework: (<https://gohugo.io/documentation/>). There are four main folders that are used.

- Archetypes
  - Files that specify the format of the front-matter that is generated when 'hugo new' is used to create new content for specfic folders.
- Content
  - Markdown files holding the information will be used to automatically generate html pages.
  - To create a new page 'hugo new [filename]' must be used, otherwise page will not register with hugo.
    - Example: 'hugo new members/newMember.md'
  - This is the main folder for adding and editing content.



- need to change baseURL in config.toml to host URL, referenced with absURL
- hugo server -D
- hugo new content/ ..
- archetypes hold metadata template info
- permalink note
  - baseURL      : <http://example.org/some/directory/>
  - Permalink    : <http://example.org/some/directory/films/o_brother/>
  - RelPermalink : </some/directory/films/o_brother/>

### to add new member

- 'hugo new member/current/membername.md'
- fill in frontmatter
- description and links go in md body
- any link included in member md page will automatically be turned into a link button

### notes

