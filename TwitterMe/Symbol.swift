//
//  Symbol.swift
//  TwitterMe
//The enitities section will contain a symbols array containing an object for every $cashtag included in the Tweet body, and include an empty array if no symbol is present
//The PowerTrack $ Operator is used to match on the text attribute.
//

import Foundation


class Symbol {
    
    
    //First integer represents the lcoation of the $ character in the Tweet text string.
    //The second integer represents the location of the first character after the cashtag
    var indices: [Int]?
    let indicesKey = "indices"
    
    //Name of the cashtag minus the leading '$' character. Example
    var text: String?
    let textKey = "text"
    
    init(dictionary: NSDictionary){
        if let indices = dictionary[indicesKey] as? [Int] {
            self.indices = indices
        }
        
        if let text = dictionary[textKey] as? String {
            self.text = text
        }
    
    }
    
    
    
    
    class func toSymbolArray(from symbolDictionaries: [NSDictionary]) -> [Symbol] {
        let symbols: [Symbol] = []
        
        for symbolDictionary in symbolDictionaries {
             symbols.append(Symbol(dictionary: symbolDictionary))
        }
        
        
        return symbols
    }


}
