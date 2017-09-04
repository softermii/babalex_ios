//
//  SFCarouselCollectionViewLayout.swift
//  testCarousel
//
//  Created by romiroma on 8/22/17.
//  Copyright © 2017 romiroma. All rights reserved.
//

import UIKit


public enum SFCarouselCollectionViewLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}


final class SFCarouselCollectionViewLayout: UICollectionViewFlowLayout {

    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionViewScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }

    override open class var layoutAttributesClass: AnyClass {
        get {
            return SFCarouselCollectionViewLayoutAttributes.self
        }
    }

    @IBInspectable open var sideItemScale: CGFloat = 0.5

    open var spacingMode = SFCarouselCollectionViewLayoutSpacingMode.fixed(spacing: -20)

    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)

    override open func prepare() {
        super.prepare()

        let currentState = LayoutState(size: self.collectionView!.bounds.size, direction: self.scrollDirection)

        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }

    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollViewDecelerationRateFast {
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        }
    }

    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }

        let collectionSize = collectionView.bounds.size

        let yInset: CGFloat = 0
        let xInset = (collectionSize.width - self.itemSize.width) / 2

        self.sectionInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset)

        let side = self.itemSize.width
        let scaledItemOffset = (side - side * self.sideItemScale) / 2
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset

            self.minimumLineSpacing = xInset - fullSizeSideItemOverlap
        }
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let newRect = CGRect.init(x: rect.minX - 50, y: rect.minY, width: rect.width + 100, height: rect.height)

        guard let superAttributes = super.layoutAttributesForElements(in: newRect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }

        let collectionCenter = collectionView.bounds.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset

        let maxDistance = collectionView.bounds.size.width
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance


        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale

        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.center.y = (maxDistance * maxDistance - distance * distance).squareRoot()

        attributes.zIndex = Int(10 * scale)

        var blurRadius: CGFloat

        blurRadius = (1 - ratio) * 5

        (attributes as? SFCarouselCollectionViewLayoutAttributes)?.blurRadius = blurRadius

        let alpha: CGFloat = ratio

        (attributes as? SFCarouselCollectionViewLayoutAttributes)?.textAlpha = alpha

        return attributes
    }

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

        let midSide = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide

        var targetContentOffset: CGPoint

        let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
        targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        return targetContentOffset
    }
}
