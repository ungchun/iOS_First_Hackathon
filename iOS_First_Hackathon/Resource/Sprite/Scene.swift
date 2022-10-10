import Foundation
import SpriteKit

// MARK: SpriteKit
class SnowScene: SKScene {
    
    override func didMove(to view: SKView) {
        setScene(view)
        setSnowNode()
    }
    
    override func didApplyConstraints() {
        guard let view = view else { return }
        scene?.size = view.frame.size
    }
    
    private func setScene(_ view: SKView) {
        backgroundColor = .clear
        scene?.anchorPoint = CGPoint(x: 0.5, y: 1)
        scene?.scaleMode = .aspectFill
    }
    
    private func setSnowNode() {
        guard let snowNode = SKEmitterNode(fileNamed: "snow") else { return }
        snowNode.position = .zero
        scene?.addChild(snowNode)
    }
}

class RainScene: SKScene {
    
    override func didMove(to view: SKView) {
        print("???? didMove")
        setScene(view)
        setRainNode()
    }
    
    override func didApplyConstraints() {
        guard let view = view else { return }
        scene?.size = view.frame.size
    }
    
    private func setScene(_ view: SKView) {
        backgroundColor = .clear
        scene?.anchorPoint = CGPoint(x: 0.5, y: 1)
        scene?.scaleMode = .aspectFill
    }
    
    private func setRainNode() {
        guard let rainNode = SKEmitterNode(fileNamed: "rain") else { return }
        rainNode.position = .zero
        scene?.addChild(rainNode)
    }
}

