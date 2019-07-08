import TPPDF

class PDF {
    static func createPDF(with text: String, and image: UIImage)-> URL? {
        let document = PDFDocument(format: .a5)
        document.add(.contentCenter, image: PDFImage(image: image))
        document.add(.contentCenter, textObject: PDFSimpleText(text: text))
        
        do {
            let url = try PDFGenerator.generateURL(document: document,
                                                   filename: "CreatedGood.pdf")
            
            return url
        } catch {
            print(error)
            return nil
        }
    }
}
