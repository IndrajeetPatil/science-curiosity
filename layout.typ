#let ink = rgb("203d3b")
#let muted = rgb("526461")
#let rule = rgb("cbd5d1")
#let gold = rgb("ae7546")
#let paper = rgb("faf8f1")
#let devanagari(n) = numbering("१", n)
#let figures = json("figures.json")

#let book-figure(n) = {
  let item = figures.at(n - 1)
  figure(
    image(item.path, width: item.width * 1mm, height: item.height * 1mm, fit: "contain", alt: item.caption),
    caption: [#item.caption #v(4pt)#text(font: "Mukta", size: 9.3pt, fill: muted)[#item.credit]],
    supplement: [चित्र],
  )
}

#let processor-table() = {
  figure(
    {
      set text(size: 10pt)
      set par(justify: false, leading: 0.75em)
      table(
        columns: (0.65fr, 1.1fr, 1fr, 1.1fr, 1.2fr),
        inset: (x: 5pt, y: 8pt),
        stroke: none,
        align: (left, left, right, right, right),
        fill: (_, y) => if y == 0 { rgb("eaf0ed") } else if calc.even(y) { rgb("f6f8f6") } else { none },
        table.header(
          [वर्ष], [प्रोसेसरचे नाव], [प्रक्रिया\ (नैनोमीटर)], [वेग\ (क्रिया/सेकंद)], [ट्रान्झिस्टर्सची\ संख्या],
        ),
        table.hline(stroke: 0.6pt + rule),
        [१९७२], [८००८], [१०,०००], [५ लाख], [३५००],
        [१९८५], [८०३८६], [१५००], [१.६ कोटी], [२७५,०००],
        [१९९३], [पेंटियम], [८००], [६.३ कोटी], [३१ लाख],
        [१९९७], [पेंटियम-२], [३५०], [३० कोटी], [७५ लाख],
        [२०००], [पेंटियम-४], [१८०], [२ अब्ज], [४.२ कोटी],
        [२००६], [कोर-२], [६५], [२.३ अब्ज], [२९.१ कोटी],
        [२०१०], [झिऑन], [४५], [२.७ अब्ज], [२.३ अब्ज],
        table.hline(stroke: 0.6pt + rule),
      )
    },
    kind: table,
    supplement: [कोष्टक],
    caption: [निवडक इंटेल प्रोसेसर्सची तुलना. आकडेवारी मूळ २०११ च्या लेखाप्रमाणे.],
  )
}

#let book(body) = {
  set document(
    title: "विज्ञान कुतूहल | Science Curiosity",
    author: "इंद्रजीत पाटील",
    date: datetime(year: 2026, month: 9, day: 10),
    description: "दहा मराठी विज्ञानलेखांचा संग्रह. मूळ लेख: २०११. नव्या मांडणीतील आवृत्ती: २०२६.",
    keywords: ("विज्ञान", "मराठी", "लोकसत्ता", "popular science", "Marathi", "Science Curiosity"),
  )
  set page(width: 160mm, height: 240mm, margin: (inside: 21mm, outside: 18mm, top: 20mm, bottom: 21mm), binding: left)
  set text(font: "Tiro Devanagari Marathi", size: 12.5pt, lang: "mr", fill: rgb("202a29"), hyphenate: false)
  // Keep Devanagari shaping intact: no character-level tracking or justification.
  // Optimise captions and other ragged text as well as justified body paragraphs.
  set par(justify: true, leading: 1.05em, spacing: 1.45em, linebreaks: "optimized")
  set heading(numbering: "1")
  show heading.where(level: 2): set heading(numbering: none)
  set figure(placement: auto, gap: 11pt, numbering: devanagari)
  set place(clearance: 18pt)
  show figure.caption: set text(size: 10pt, fill: muted)
  show figure.caption: set align(left)
  show figure.caption: set par(justify: false, leading: 0.9em)
  show figure: set block(above: 18pt, below: 20pt)
  show link: set text(fill: ink)
  // Chapters open on a right-hand (odd) page, as in printed books.
  show heading.where(level: 1): it => {
    pagebreak(weak: true, to: "odd")
    v(9mm)
    text(font: "Mukta", size: 10pt, fill: gold)[लेख #context counter(heading).display(devanagari)]
    v(3mm)
    block(width: 100%, {
      set par(justify: false, leading: 0.76em)
      text(size: 25pt, fill: ink, it.body)
    })
    v(4mm)
    line(length: 18mm, stroke: 1pt + gold)
    v(7mm)
  }
  // Style the heading's own block so its default spacing cannot override ours.
  // Roughly a blank line above and below sets each section heading apart.
  show heading.where(level: 2): set block(above: 30pt, below: 18pt, sticky: true)
  show heading.where(level: 2): set text(font: "Mukta", size: 13.5pt, weight: "bold", fill: ink)
  body
}
