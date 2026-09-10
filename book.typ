#import "layout.typ": *
#show: book

// A typographic cover with an original orbital drawing.
#page(margin: (x: 22mm, y: 20mm), fill: paper, header: none, footer: none)[
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
  #v(2mm)
  #text(font: "Mukta", size: 9pt, fill: muted)[मराठी · दहा लेख · २०११]
]

#page(header: none, footer: none)[
  #v(17mm)
  #text(size: 27pt, fill: ink)[विज्ञान कुतूहल]
  #v(4mm)
  #text(size: 15pt)[इंद्रजीत पाटील]
  #v(17mm)
  #text(font: "Mukta", size: 12pt, fill: ink)[या आवृत्तीविषयी]
  #v(3mm)
  या संग्रहातील दहा विज्ञानलेख प्रथम २०११ मध्ये मराठी दैनिक ‘लोकसत्ता’मध्ये प्रसिद्ध झाले. प्राण्यांची जाणीव, अवकाशातील रेणू, संगणक, मानवी शरीर आणि पदार्थांचे विलक्षण गुणधर्म अशा विविध विषयांचा येथे वेध घेतला आहे.

  ही मूळ लेखांची नव्या मांडणीतील आवृत्ती आहे. लेखांतील आकडेवारी, तत्कालीन संशोधनाचा संदर्भ आणि भविष्याविषयीची विधाने मूळ प्रकाशनकाळाच्या संदर्भात वाचावीत. मजकुराचे शास्त्रीय अद्ययावतीकरण केलेले नाही.

  या आवृत्तीत नवी अक्षररचना, अनुक्रमणिका, चित्रविवरणे आणि चित्रस्रोतांची नोंद जोडली आहे. स्रोतांची खात्री जिथे झालेली नाही, तिथे तसे स्पष्ट नमूद केले आहे.
  #v(1fr)
  #line(length: 100%, stroke: 0.6pt + rule)
  #v(4mm)
  #text(size: 9pt, fill: muted)[
    मूळ लेख: २०११\
    पुनर्मांडणी: सप्टेंबर २०२६\
    अक्षररचना: Tiro Devanagari Marathi आणि Mukta\
    #link("https://www.indrapatil.com/writing/")[www.indrapatil.com/writing/]
  ]
]

#page(header: none, footer: none)[
  #text(size: 28pt, fill: ink)[अनुक्रमणिका]
  #v(5mm)
  #text(size: 10pt, fill: muted)[लेखाच्या शीर्षकावर क्लिक करून त्या पानावर जाता येईल.]
  #v(8mm)
  #show outline.entry: it => block(above: 7pt, below: 7pt)[
    #link(it.element.location())[
      #grid(columns: (1fr, 10mm), column-gutter: 4mm,
        [#it.element.body],
        align(right)[#context devanagari(counter(page).at(it.element.location()).first())],
      )
    ]
    #v(5pt)
    #line(length: 100%, stroke: 0.35pt + rule)
  ]
  #outline(title: none, depth: 1)
]

#counter(page).update(1)
#set page(
  header: context {
    set text(size: 8pt, fill: muted)
    let p = counter(page).get().first()
    if calc.odd(p) { align(right)[विज्ञान कुतूहल] } else { [इंद्रजीत पाटील] }
  },
  footer: context {
    set text(size: 9pt, fill: muted)
    align(center)[#devanagari(counter(page).get().first())]
  },
)
#include "chapters/01-self-awareness.typ"
#place.flush()
#include "chapters/02-buckyballs.typ"
#place.flush()
#include "chapters/03-immunity.typ"
#place.flush()
#include "chapters/04-moores-law.typ"
#place.flush()
#include "chapters/05-machine-intelligence.typ"
#place.flush()
#include "chapters/06-lie-detection.typ"
#place.flush()
#include "chapters/07-perpetual-motion.typ"
#place.flush()
#include "chapters/08-thermoregulation.typ"
#place.flush()
#include "chapters/09-metamaterials.typ"
#place.flush()
#include "chapters/10-regeneration.typ"

#place.flush()
#pagebreak()
#show heading.where(level: 1): it => block(above: 8mm, below: 9mm)[#text(size: 26pt, fill: ink)[#it.body]]
#heading(level: 1, numbering: none)[चित्रस्रोत आणि आभार]
#include "credits.typ"
