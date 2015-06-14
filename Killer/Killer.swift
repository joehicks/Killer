//
//  Killer.swift
//  Killer
//
//  Created by Joe Hicks on 26/05/2015.
//  Copyright (c) 2015 Joe Hicks. All rights reserved.
//

import Foundation
import UIKit

var players = [Player]()

class Player {
    var name:String
    var num:Int
    var order = Int()
    var i = Int()
    var throw = 0
    var killer = false
    var lives = 3
    var tgt = [Int]()
    var numTgt = [Int(),Int(),Int()]
    var didHit:[Int] = [1, 1, 1]
    var didTargets:[Int] = [0, 0, 0]
    var hits:Int = 0
    var misses:Int = 0
    var accuracy:Double {
        get {
            if hits + misses == 0 {
                return 0
            } else {
                return Double(hits) / Double(hits + misses)
            }
        }
    }
    var timesHit: Int = 0
    var timesMissed: Int = 0
    var percentageTimesHit: Double {
        get {
            if timesHit + timesMissed == 0 {
                return 0
            } else {
                return Double(timesHit) / Double(timesHit + timesMissed)
            }
        }
    }
    var alive:Bool = true
    //var players = [Player]()
    
    init(name: String, num: Int) {
        self.name = name
        self.num = num
    }
    
    func targets(forThrow:Int) {
        if tgt == [Int]() {
            tgt = [i, i, i]
        }
        /*var numberList = [Int]()
        for j in 0..<players.count {
            if j != i {
                numberList.append(j)
            }
        }
        if killer {
            if forThrow < 2 {
                for j in 0...2 {
                    tgt[j] = (i + j + 1) % numberList.count
                }
            } else if forThrow == 2 {
                
            }
        }*/
        if killer && throw < 3 {
            var otherPlayers = players
            otherPlayers.removeAtIndex(i)
            for j in throw...2 {
                tgt[j] = otherPlayers[(i+j-throw) % otherPlayers.count].i
            }
        }
        if throw < 3 {
            numTgt = [players[tgt[0]].num,players[tgt[1]].num,players[tgt[2]].num]
        }
        //println("targets for \(name) = \(tgt)")
    }
    func dart(hit: Bool) {
        didTargets[throw - 1] = players[tgt[throw - 1]].num
        if hit {
            hits++
            didHit[throw - 1] = 2
            if !killer {
                killer = true
                targets(throw + 1)
            } else {
                players[tgt[throw - 1]].lives--
                if players[tgt[throw - 1]].lives == 0 {
                    players[tgt[throw - 1]].dead()
                    if players.count > 1 {
                        if throw != 3 {
                            if throw == 1 && players.count == 2 {
                                tgt[1] = 1 - i
                                tgt[2] = 1 - i
                                numTgt[1] = players[1 - i].num
                                numTgt[2] = players[1 - i].num
                            } else {
                                for j in throw...2 {
                                    tgt[j] = num2id[numTgt[j]]!
                                }
                            }
                        }
                    }
                }
            }
        } else {
            misses++
            didHit[throw - 1] = 0
        }
    }
    func dead() {
        alive = false
        disp()
        players.removeAtIndex(i)
        if i < go {
            go--
        }
        index()
        
    }
    func copy() -> StructPlayer {
        var newStruct = StructPlayer(name: name, num: num, order: order, i: i, throw: throw, killer: killer, lives: lives, tgt: tgt, numTgt: numTgt, hits: hits, misses: misses, timesHit: timesHit, timesMissed: timesMissed, alive: alive, didHit: didHit, didTargets: didTargets)
        return newStruct
        
    }
    
}

struct StructPlayer {
    var name:String
    var num:Int
    var order = Int()
    var i = Int()
    var throw = 0
    var killer = false
    var lives = 3
    var tgt = [Int]()
    var numTgt = [Int]()
    var hits:Int = 0
    var misses:Int = 0
    var timesHit: Int = 0
    var timesMissed: Int = 0
    var alive:Bool = true
    var didHit = [Int]()
    var didTargets = [Int]()
}



var go = Int()
var dispPlayers = [StructPlayer]()

func index() {
    var i = 0
    for player in players {
        player.i = i
        i++
    }
    updateDic()
}
func testPrint() {
    println("Test!")
}
func setup() {
    index()
    var i = 0
    for player in players {
        player.order = player.i
        i++
    }
    for player in players {
        dispPlayers.append(player.copy())
    }
    go = 0
}


func disp() {
    for player in players {
        dispPlayers[player.order] = player.copy()
    }
}
func updateDic() {
    num2id = [Int: Int]()
    for player in players {
        num2id.updateValue(player.i, forKey: player.num)
    }
}
func cleanup() {
    players = [Player]()
    dispPlayers = [StructPlayer]()
    go = Int()
}
