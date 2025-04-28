### 0.9

- New cover!
- "Predicate Logic" chapter now uses a programmer-centric example to motivate quantifiers
- "Writing Better Tests" chapter motivates proptesting better, formalizes concept of "test strength"
- "Solvers" chapter expanded, better coverage of SMT solvers and more discussion on choosing the right solver for your problem
- "Logic Programming" chapter wholly rewritten, examples are no longer toy problems
- "Beyond Logic" appendix has simpler example of non-constructive proofs
- Code samples now highlight added/removed code
- Large code samples now available online at |code-samples|
- Fixed bug where index was missing from PDF version
- Reduced epub filesize to 5mb to 800kb
- Various copyedits and fixes
- One new exercise

### 0.8

- Notes, tips, and exercises now all use unified format
- Changed line spacing a little
- "Predicate logic" chapter partially rewritten to introduce predicates earlier and more formally
- One new exercise

### 0.7

- New fonts!
- Changed formatting and indentation for code blocks
- "Functional Correctness" chapter has new section on type invariants
- "Data Modeling" chapter has new example on finding design bugs via modeling
- "Conditionals" chapter now covers redundant conditionals more broadly
- Rewrote intro, "Why this book" section cleaner
- Incorporated various reader feedback

### 0.6

- Exercises are more compact, answers now show name of exercise in title (pdf only)
- "Conditionals" chapter has new section on nested conditionals
- "Crash course" chapter significantly rewritten + example no longer about clubbing
- Starting migrating to use consistently use ``==`` for equality and ``=`` for definition. Not everything is migrated yet
- "Beyond Logic" appendix does a *slightly* better job of covering HOL and constructive logic
- Addressed various reader feedback
- Two new exercises

### 0.5

- "Further Reading" section for technique chapters
- "System modeling" chapter significantly rewritten
- "Conditionals" chapter expanded, now a real chapter
- "Logic Programming" chapter now covers datalog, deductive databases
- "Solvers" chapter has diagram explaining problem
- Eight new exercises
- Tentative front cover (will probably change)
- Fixed some epub issues with math rendering
- Book now officially in beta

### 0.4

Content:

- New chapter: "System Modeling", about TLA+.
- "Tools" chapter split into "solvers" and "logic programming".
- "Solvers" expanded and has real-world motivating problem now instead of toy problem. 
- 0.3 didn't actually have the claimed Z3 example. Now added for real.
- "Logic programming" now covers planning (with example)
- "Data modeling" and "Database invariants" revised
- "Testing" chapter has more explanation of how to use PBT in the ways people actually use it
- Removed dangling content in the functional correctness chapter
- Epub and PDF now have "acknowledgements" section


### 0.3

Epub:

- Fixed rendering issue on epub: math symbols like ∀ were showing up as \(\forall\). This should be fixed for *most* math symbols now.

PDF:

Mostly learning how to customize Sphinx's output.

- Fancier header shows chapter and section
- Page size no longer "sheet of office paper"
- Larger font
 
Content:

- Z3 section now has an example, thanks to Nelson Elhage
- Rewrote part of functional correctness section, incl. better discussion of the what and why of loop invariants.
- Incorporated some feedback about the implication section of chapter 2. Yes, your feedback matters!
- A couple more exercises (not many)

### 0.2

- More on constraint solvers, SAT, and SMT. That section's now 800 words and might eventually be a new chapter.
- Rewrote the logic programming section.
- New exercises (dt)
- More on data modeling, Alloy, and how it benefits your implementations
- Started work on "Beyond logic", an enrichment appendix about advanced topics in logic: modal logic, constructive logic, higher order logic, etc. Tentative, may not be in the final book.
- More persuasive introduction

