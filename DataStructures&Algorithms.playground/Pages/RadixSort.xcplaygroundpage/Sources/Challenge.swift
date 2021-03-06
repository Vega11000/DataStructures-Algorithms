import Foundation


extension Int {
    var digits: Int {
        var count = 0
        var num = self
        
        while num != 0 {
            count += 1
            num /= 10
        }
        
        return count
    }
    
    func digit(atPosition position: Int) -> Int? {
        guard position < digits else {
            return nil
        }
        
        var num = self
        let correctedPosition = Double(position + 1)
        
        while num / Int(pow(10.0, correctedPosition)) != 0 {
            num /= 10
        }
        
        return num % 10
    }
}

extension Array where Element == Int {
    
    private var maxDigits: Int {
        self.max()?.digits ?? 0
    }
    
    public mutating func lexicographicalSort() {
        self = msdRadixSorted(self, 0)
    }
    
    private func msdRadixSorted(_ array: [Int], _ position: Int) -> [Int] {
        
        guard position < array.maxDigits else {
            return array
        }
        
        var buckets: [[Int]] = .init(repeating: [], count: 10)
        
        var priorityBucket: [Int] = []
        
        array.forEach { number in
            guard let digit = number.digit(atPosition: position) else {
                priorityBucket.append(number)
                return
            }
            buckets[digit].append(number)
        }
        
        priorityBucket.append(contentsOf: buckets.reduce(into: []) { result, bucket in
            guard !bucket.isEmpty else {
                return
            }
            result.append(contentsOf: msdRadixSorted(bucket, position + 1)) })
        
        return priorityBucket
    }
}
