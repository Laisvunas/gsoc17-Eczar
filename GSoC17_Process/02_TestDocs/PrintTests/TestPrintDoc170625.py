# For DrawBot 
# Use it with these files installed:
# Eczar-ExtraBold_170625.ufo
size("A4Landscape")
font("Eczar Regular_170625")

fontSize(100)
tracking(20)
textBox("αάβγδεέζηήθιΐίϊκλμνξοόπρςστυΰϋύφχψωώ", (30, -30, width()-100, height()))

fill(0.5)
fontSize(9)
tracking(0)
textBox("Emilios Theofanous / GSoC17 - Adding Greek to the Open-Source Type Family Eczar / Eczar_Regular_170625 / TestPrintDoc17062ρ5 / p1|2", (30, 10, width(), 30), align="left")

newPage("A4Landscape")

font("Eczar Regular_170625")
lineHeight(12)
language("Greek")
hyphenation(True)

TestText = '''
Μισοπλαγιασμένη κοντά εις την εστίαν, με σφαλιστά τα όμματα, την κεφαλήν ακουμβώσα εις το κράσπεδον της εστίας, το λεγόμενον «φουγοπόδαρο», η θεια-Χαδούλα, η κοινώς γιαννού η φράγκισσα, δεν εκοιμάτο, αλλ’ εθυσίαζε τον ύπνο πλησίον εις το λίκνον της ασθενούσης μικράς εγγονής της. Όσον διά την λεχώ, την μητέρα του πάσχοντος βρέφους, αύτη προ ολίγου είχεν αποκοιμηθή επί της χθαμαλής, πενιχράς κλίνης της. 


textBox(TestText, (30, -10, 227, height()))

fontSize(14)
lineHeight(16)


textBox(TestText, (300, height()/2-4, 500, height()/2))

fontSize(20)
lineHeight(23)

textBox(TestText, (300, height()/2-250, 500, 250))   

fill(0.5)
fontSize(9)
textBox("Emilios Theofanous / GSoC17 - Adding Greek to the Open-Source Type Family Eczar / Eczar_Regular_170625 / TestPrintDoc170625 / Sample text: “The murderess” - A. Papadiamantis / p2|2 ", (30, 10, width(), 30), align="left")

saveImage("TestPrintDoc170625.pdf")