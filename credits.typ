#import "layout.typ": figures, devanagari, ink, muted, rule, gold
#let chapters = json("chapters.json")
#set text(size: 11.5pt)
#set par(justify: false, leading: 0.85em, spacing: 1.3em)

या पुस्तकातील चित्रे तयार करणाऱ्या कलाकारांचे, छायाचित्रकारांचे आणि ती जतन करणाऱ्या संस्थांचे ऋण येथे नोंदवले आहे. प्रत्येक चित्राखाली नव्याने जोडलेले मराठी विवरण दिले आहे.

प्रत्येक नोंदीत चित्राचा निर्माता, मूळ स्रोत आणि पुनर्वापराचा परवाना दिला आहे. चित्रस्रोतांची तपासणी नोव्हेंबर २०२६ मध्ये करण्यात आली.

#for item in figures {
  let ch = chapters.at(item.id - 1)
  block(breakable: false, above: 5.5mm, below: 1.5mm)[
    #text(font: "Mukta", size: 12pt, weight: "bold", fill: ink)[लेख #devanagari(item.id): #ch.title]
    #v(1.5mm)
    #text(font: "Mukta", size: 10pt, fill: gold)[चित्र #devanagari(item.id)] --- #item.note
    #if item.source != none [
      #v(3pt)
      #text(font: "Mukta", size: 10pt, fill: muted)[#link(item.source)[मूळ स्रोत / संग्रहातील नोंद ↗]]
    ]
  ]
}

#block(breakable: false, above: 7mm)[
  #line(length: 100%, stroke: 0.6pt + rule)
  #v(4mm)
  #text(font: "Mukta", size: 12pt, fill: ink)[अक्षररचना आणि मुखपृष्ठ]

  Tiro Devanagari Marathi: Tiro Typeworks. Mukta: Ek Type. दोन्ही अक्षरकुटुंबे SIL Open Font License अंतर्गत उपलब्ध आहेत. या आवृत्तीच्या मुखपृष्ठावरील भूमितीय रेखाचित्र नव्याने तयार केले आहे; ते एखाद्या अणूचे वैज्ञानिक प्रतिरूप नाही.
]
