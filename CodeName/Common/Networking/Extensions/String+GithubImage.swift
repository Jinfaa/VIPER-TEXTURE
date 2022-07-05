extension String
{
    func getGithubImageUrl() -> URL? {
        let pattern = "]\\((.*?\\.svg|\\.jpg|\\.gif)\\)"
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        var url: URL?
        if let match = matches?.first {
            let range = match.range(at: 1)
            if let swiftRange = Range(range, in: self) {
                url = URL(string: String(self[swiftRange]))
            }
        }
        
        return url
    }
}
