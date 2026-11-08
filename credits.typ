#import "layout.typ": figures, devanagari, ink, muted, rule
#set text(size: 11.5pt)
#set par(justify: false, leading: 0.85em, spacing: 1.3em)

या पुस्तकातील चित्रे तयार करणाऱ्या कलाकारांचे, छायाचित्रकारांचे आणि ती जतन करणाऱ्या संस्थांचे ऋण येथे नोंदवले आहे. प्रत्येक चित्राखाली नव्याने जोडलेले मराठी विवरण दिले आहे. मूळ प्रतिमा आणि त्यांची उपलब्ध गुणवत्ता जतन केली आहे.

चित्रस्रोतांची तपासणी सप्टेंबर २०२६ मध्ये करण्यात आली. खालील नोंदींमध्ये निश्चित ओळख, प्रतिमेवर छापलेले श्रेयनाम आणि अद्याप न सापडलेला स्रोत यांतील फरक स्पष्ट केला आहे.

#for item in figures {
  if item.id in (4, 8) {
    pagebreak()
    text(size: 20pt, fill: ink)[चित्रस्रोत आणि आभार]
    v(4mm)
  }
  block(breakable: false, above: 7mm, below: 2mm)[
    #grid(columns: (12mm, 1fr), column-gutter: 3mm,
      text(font: "Mukta", size: 16pt, fill: ink)[#devanagari(item.id)],
      [
        #item.note
        #if item.source != none [
          #v(4pt)
          #text(font: "Mukta", size: 10pt, fill: muted)[#link(item.source)[मूळ स्रोत / संग्रहातील नोंद ↗]]
        ]
      ],
    )
  ]
}

#block(breakable: false, above: 9mm)[
  #line(length: 100%, stroke: 0.6pt + rule)
  #v(5mm)
  #text(font: "Mukta", size: 12pt, fill: ink)[अक्षररचना आणि मुखपृष्ठ]

  Tiro Devanagari Marathi: Tiro Typeworks. Mukta: Ek Type. दोन्ही अक्षरकुटुंबे SIL Open Font License अंतर्गत उपलब्ध आहेत. या आवृत्तीच्या मुखपृष्ठावरील भूमितीय रेखाचित्र नव्याने तयार केले आहे; ते एखाद्या अणूचे वैज्ञानिक प्रतिरूप नाही.
]
