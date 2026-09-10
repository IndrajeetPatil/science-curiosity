या पुस्तकातील चित्रे तयार करणाऱ्या कलाकारांचे, छायाचित्रकारांचे आणि ती जतन करणाऱ्या संस्थांचे ऋण येथे नोंदवले आहे. प्रत्येक चित्राखाली नव्याने जोडलेले मराठी विवरण दिले आहे. मूळ प्रतिमा आणि त्यांची उपलब्ध गुणवत्ता जतन केली आहे.

चित्रस्रोतांची तपासणी सप्टेंबर २०२६ मध्ये करण्यात आली. खालील नोंदींमध्ये निश्चित ओळख, प्रतिमेवर छापलेले श्रेयनाम आणि अद्याप न सापडलेला स्रोत यांतील फरक स्पष्ट केला आहे.

#import "layout.typ": figures, devanagari, ink, muted
#for item in figures {
  block(breakable: false, above: 10pt, below: 5pt)[
    #text(font: "Mukta", size: 11pt, fill: ink)[चित्र #devanagari(item.id)]
    #linebreak()
    #item.note
    #if item.source != none [
      #linebreak()
      #text(size: 9pt, fill: muted)[#link(item.source)[मूळ स्रोत / संग्रहातील नोंद ↗]]
    ]
  ]
}

#v(8mm)
#text(font: "Mukta", size: 12pt, fill: ink)[अक्षररचना आणि मुखपृष्ठ]

Tiro Devanagari Marathi: Tiro Typeworks. Mukta: Ek Type. दोन्ही अक्षरकुटुंबे SIL Open Font License अंतर्गत उपलब्ध आहेत. या आवृत्तीच्या मुखपृष्ठावरील भूमितीय रेखाचित्र नव्याने तयार केले आहे; ते एखाद्या अणूचे वैज्ञानिक प्रतिरूप नाही.
