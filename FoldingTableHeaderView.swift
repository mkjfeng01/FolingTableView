// MIT License
//
// Copyright (c) 2019 张_ zfeng0712@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

fileprivate struct FoldingTableHeaderUX {
    static let margin: CGFloat = 15
    static let padding: CGFloat = 5
}

open class FoldingTableHeaderView: UIView {
    
    public weak var delegate: FoldingTableHeaderViewDelegate?
    
    public lazy var contentView = UIImageView()
    
    public var customView: UIView? {
        didSet {
            if let custom = self.customView {
                self.addSubview(custom)
            }
        }
    }
    
    public lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    public lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    public private(set) var tapGesture: UITapGestureRecognizer!
    public private(set) var reuseIdentifier: String
    
    public private(set) var indicatorPosition: FoldingTableViewIndicatorPosition
    public private(set) var state: FoldingTableViewFoldState
    public private(set) var section: Int
    
    /// This property only works when the `customeView` was NOT set
    /// Default value is false
    public private(set) var isTransforming: Bool
    
    public init(frame: CGRect, state: FoldingTableViewFoldState, indicatorPosition: FoldingTableViewIndicatorPosition, section: Int, reuseIdentifier: String) {
        self.section = section
        self.reuseIdentifier = reuseIdentifier
        
        self.indicatorPosition = indicatorPosition
        self.state = state
        
        self.isTransforming = false
        
        super.init(frame: frame)
        
        if case .expand = state {
            indicatorImageView.transform = CGAffineTransform(rotationAngle:  CGFloat.pi/2)
        }
        
        if case .trailing = indicatorPosition {
            indicatorImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
        
        contentView.frame = frame
        addSubview(contentView)
        
        contentView.addSubview(titleTextLabel)
        contentView.addSubview(descriptionTextLabel)
        contentView.addSubview(indicatorImageView)
    }
    
    convenience init(frame: CGRect, state: FoldingTableViewFoldState = .fold, indicatorPosition: FoldingTableViewIndicatorPosition = .leading, section: Int) {
        let reuseIdentifier = "tableView.folding.header.identifier.\(section)"
        self.init(frame: frame, state: state, indicatorPosition: indicatorPosition, section: section, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(customView: UIView, section: Int) {
        self.init(frame: .zero, state: .fold, indicatorPosition: .leading, section: section)
        self.customView = customView
    }
    
    convenience init(section: Int) {
        self.init(frame: .zero, state: .fold, indicatorPosition: .leading, section: section)
    }
    
    public func setupConstraints() {
        for constraint in self.constraints { removeConstraint(constraint) }
        
        if let customView = customView, contentView.subviews.contains(customView) {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[customView]-(margin)-|",
                                                                      options: [],
                                                                      metrics: ["margin": FoldingTableHeaderUX.margin],
                                                                      views: ["customView": customView]))
        } else {
            
            let views =  ["indicatorImageView": indicatorImageView, "titleTextLabel": titleTextLabel, "descriptionTextLabel": descriptionTextLabel]
            let metrics = ["padding": FoldingTableHeaderUX.padding, "margin": FoldingTableHeaderUX.margin]
            
            /// Shold always setup constraints for contentView, even if `customView` was set.
            
            for view in views.values {
                contentView.addConstraint(NSLayoutConstraint(item: view,
                                                             attribute: .centerY,
                                                             relatedBy: .equal,
                                                             toItem: contentView,
                                                             attribute: .centerY,
                                                             multiplier: 1.0,
                                                             constant: 0.0))
            }
            
            if case .leading = indicatorPosition {
                contentView.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[indicatorImageView]-(padding)-[titleTextLabel]-(padding)-[descriptionTextLabel]-(margin)-|",
                                                   options: [], metrics: metrics,
                                                   views: views))
            } else {
                contentView.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[titleTextLabel]-(padding)-[descriptionTextLabel]-(padding)-[indicatorImageView]-(margin)-|",
                                                   options: [], metrics: metrics,
                                                   views: views))
            }
        }
    }
    
    @objc public func onTapGesture(_ sender: UITapGestureRecognizer) {
        if isTransforming { return }
        state = (state == .fold) ? .expand : .fold
        
        if customView == nil {
            shouldMakeTransform(true)
        }
        
        delegate?.foldingTableHeaderView(self, didSelectHeaderInSection: section)
    }
    
    public func shouldMakeTransform(_ animated: Bool) {
        if let customView = customView, contentView.subviews.contains(customView) {
            /// Custom view has been set, the transition animation excute outside.
            return
        }
        
        isTransforming = true
        
        UIView.animate(withDuration: animated ? 0.2 : 0.0,
                       animations: {
                        var angle: CGFloat = 0.0
                        if self.state == .fold {
                            angle = (self.indicatorPosition == .leading) ? 0.0 : CGFloat.pi
                        } else {
                            angle = CGFloat.pi/2
                        }
                        self.indicatorImageView.transform = CGAffineTransform(rotationAngle: angle)
        }) { _ in
            self.isTransforming = false
        }
    }
    
    public func prepareForReuse() {
        descriptionTextLabel.attributedText = nil
        titleTextLabel.attributedText = nil
        indicatorImageView.image = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
