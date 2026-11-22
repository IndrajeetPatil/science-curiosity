// Social preview card (1280 × 640 px at 144 ppi) in the cover's style.
#import "layout.typ": gold, ink, muted, paper

#set page(width: 640pt, height: 320pt, margin: 0pt, fill: paper)
#set text(font: "Tiro Devanagari Marathi", lang: "mr", fill: ink)

#grid(
  columns: (1fr, 300pt),
  rows: 100%,
  pad(left: 46pt, top: 40pt, bottom: 36pt, right: 10pt)[
    #text(font: "Mukta", size: 11pt, fill: muted)[विज्ञानलेखांचा संग्रह]
    #v(14pt)
    #text(size: 50pt)[विज्ञान कुतूहल]
    #v(6pt)
    #text(font: "Mukta", size: 13pt, fill: muted, tracking: 1.5pt)[SCIENCE CURIOSITY]
    #v(1fr)
    #line(length: 60pt, stroke: 1.2pt + gold)
    #v(10pt)
    #text(size: 18pt)[इंद्रजीत पाटील]
  ],
  align(center + horizon, image("figures/cover-orbits.svg", width: 280pt)),
)
