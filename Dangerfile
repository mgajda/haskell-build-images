# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Don't let testing shortcuts get into master by accident
fail("fdescribe left in tests") if `grep -r fdescribe specs/ `.length > 1
fail("fit left in tests") if `grep -r fit specs/ `.length > 1

# get all affected files by the changes in the current diff
affected_files = git.added_files + git.modified_files

# limit files to .hs files
haskell_files = affected_files.select { |file| file.end_with?('.hs') }

# run hlint on the files and comment inline in the PR
hlint.lint haskell_files, inline_mode: true
