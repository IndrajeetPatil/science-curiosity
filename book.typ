#import "layout.typ": *
#show: book

// A typographic cover with an original orbital drawing.
#page(margin: (x: 22mm, y: 20mm), fill: paper)[
  #set text(size: 12pt)
  #set par(leading: 0.7em, spacing: 0.82em)
  #text(font: "Mukta", size: 10pt, fill: muted)[विज्ञानलेखांचा संग्रह]
  #v(18mm)
  #text(size: 47pt, fill: ink)[विज्ञान\ कुतूहल]
  #v(5mm)
  #text(font: "Mukta", size: 12pt, fill: muted)[SCIENCE CURIOSITY]
  #v(10mm)
  #align(center)[#image("figures/cover-orbits.svg", width: 101mm)]
  #v(1fr)
  #line(length: 100%, stroke: 0.6pt + rule)
  #v(5mm)
  #text(size: 19pt, fill: ink)[इंद्रजीत पाटील]
]

// The cover's reverse stays blank so the title page opens on a right-hand page.
#page[]

#page[
  #set text(size: 12pt)
  #v(17mm)
  #text(size: 27pt, fill: ink)[विज्ञान कुतूहल]
  #v(4mm)
  #text(size: 15pt)[इंद्रजीत पाटील]
  #v(17mm)
  #text(font: "Mukta", size: 12pt, fill: ink)[या आवृत्तीविषयी]
  #v(3mm)
  या संग्रहातील दहा विज्ञानलेख प्रथम २०११ मध्ये मराठी दैनिक ‘लोकसत्ता’मध्ये प्रसिद्ध झाले. प्राण्यांची जाणीव, अवकाशातील रेणू, संगणक, मानवी शरीर आणि पदार्थांचे विलक्षण गुणधर्म अशा विविध विषयांचा येथे वेध घेतला आहे.

  ही मूळ लेखांची नव्या मांडणीतील आवृत्ती आहे. लेखांतील आकडेवारी, तत्कालीन संशोधनाचा संदर्भ आणि भविष्याविषयीची विधाने मूळ प्रकाशनकाळाच्या संदर्भात वाचावीत. मजकुराचे शास्त्रीय अद्ययावतीकरण केलेले नाही.

  या आवृत्तीत नवी अक्षररचना, अनुक्रमणिका, चित्रविवरणे आणि चित्रस्रोतांची नोंद जोडली आहे. मूळ संग्रहातील ज्या चित्रांचे स्रोत निश्चित करता आले नाहीत, त्यांच्या जागी सार्वजनिक मालकीतील किंवा मुक्त परवान्याखालील चित्रे वापरली आहेत.
  #v(1fr)
  #line(length: 100%, stroke: 0.6pt + rule)
  #v(4mm)
  #text(size: 9pt, fill: muted)[
    मूळ लेख: २०११\
    पुनर्मांडणी: सप्टेंबर २०२६\
    अक्षररचना: Tiro Devanagari Marathi आणि Mukta
  ]
]

#page(include "rights.typ")

#page[
  #text(size: 28pt, fill: ink)[अनुक्रमणिका]
  #v(5mm)
  #text(size: 10pt, fill: muted)[लेखाच्या शीर्षकावर क्लिक करून त्या पानावर जाता येईल.]
  #v(8mm)
  #show outline.entry: it => block(spacing: 7pt)[
    #link(it.element.location())[
      #grid(columns: (1fr, 10mm), column-gutter: 4mm,
        it.element.body,
        align(right)[#context devanagari(counter(page).at(it.element.location()).first())],
      )
    ]
    #v(5pt)
    #line(length: 100%, stroke: 0.35pt + rule)
  ]
  #outline(title: none, depth: 1)
]

// The contents' reverse stays blank so the first chapter opens on a right-hand page.
#page[]

// A page left blank so the next chapter opens on a right-hand page.
#let is-blank-verso() = {
  let page = here().page()
  query(<chapter-end>).any(m => m.location().page() == page - 1) and query(heading.where(level: 1)).any(h => h.location().page() == page + 1)
}

#counter(page).update(1)
#set page(
  header: context {
    if is-blank-verso() { return }
    set text(size: 8pt, fill: muted)
    let current = query(heading.where(level: 1).before(here())).last(default: none)
    let opening = query(heading.where(level: 1)).any(h => h.location().page() == here().page())
    // Quiet chapter openings; a running chapter title helps readers navigate.
    if current != none and not opening {
      if calc.odd(counter(page).get().first()) { align(right, current.body) } else [विज्ञान कुतूहल]
    }
  },
  footer: context {
    if is-blank-verso() { return }
    set text(size: 9pt, fill: muted)
    align(center, counter(page).display(devanagari))
  },
)
#for chapter in (
  "01-self-awareness",
  "02-buckyballs",
  "03-immunity",
  "04-moores-law",
  "05-machine-intelligence",
  "06-lie-detection",
  "07-perpetual-motion",
  "08-thermoregulation",
  "09-metamaterials",
  "10-regeneration",
) {
  include "chapters/" + chapter + ".typ"
  place.flush()
  [#metadata(none) <chapter-end>]
}

#pagebreak()
#show heading.where(level: 1): set block(above: 8mm, below: 9mm)
#show heading.where(level: 1): it => text(size: 26pt, fill: ink, it.body)
#heading(level: 1, numbering: none)[चित्रस्रोत आणि आभार]
#include "credits.typ"

#pagebreak()
#heading(level: 1, numbering: none)[लेखकाविषयी]
#include "author.typ"
