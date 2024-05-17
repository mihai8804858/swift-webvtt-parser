extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Sequence {
    func uniqued<Property: Hashable>(by property: (Element) -> Property) -> [Element] {
        var set = Set<Property>()
        return filter { set.insert(property($0)).inserted }
    }
}
