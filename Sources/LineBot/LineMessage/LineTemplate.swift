//
//  LineTemplate.swift
//  LineBot
//
//  Created by happiness9721 on 2018/3/20.
//

import Foundation

public enum LineTemplate {

  case button(_: Button)
  case confirm(_: Confirm)
  case carousel(_: Carousel)
  case imageCarousel(_: ImageCarousel)

  public struct Button {

    public var thumbnailImageUrl: String? = nil
    public var imageAspectRatio: ImageAspectRatio? = nil
    public var imageSize: ImageSize? = nil
    public var imageBackgroundColor: String? = nil
    public var title: String? = nil
    public var text: String
    public var defaultAction: LineAction? = nil
    public var actions: [LineAction]

    public init(text: String, actions: [LineAction]) {
      self.text = text
      self.actions = actions
    }

  }

  public struct Confirm {

    public var text: String
    public var actions: [LineAction]

    public init(text: String, actions: [LineAction]) {
      self.text = text
      self.actions = actions
    }

  }

  public struct Carousel {

    public var columns: [Column]
    public var imageAspectRatio: ImageAspectRatio?
    public var imageSize: ImageSize?

    public struct Column {

      public var thumbnailImageUrl: String?
      public var imageBackgroundColor: String?
      public var title: String?
      public var text: String
      public var defaultAction: LineAction?
      public var actions: [LineAction]

      public init(text: String, actions: [LineAction]) {
        self.text = text
        self.actions = actions
      }

      internal func toDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["thumbnailImageUrl"] = thumbnailImageUrl
        dict["imageBackgroundColor"] = imageBackgroundColor
        dict["title"] = title
        dict["text"] = text
        dict["defaultAction"] = defaultAction?.toDict()
        dict["actions"] = actions.map { $0.toDict() }
        return dict
      }

    }

    public init(columns: [Column]) {
      self.columns = columns
    }

  }

  public struct ImageCarousel {

    public var columns: [Column]

    public struct Column {

      public var imageUrl: String
      public var action: LineAction

      public init(imageUrl: String, action: LineAction) {
        self.imageUrl = imageUrl
        self.action = action
      }

      internal func toDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["imageUrl"] = imageUrl
        dict["action"] = action.toDict()
        return dict
      }

    }

    public init(columns: [Column]) {
      self.columns = columns
    }

  }

  public enum ImageAspectRatio: String {
    case rectangle = "rectangle"
    case square = "square"
  }

  public enum ImageSize: String {
    case cover = "cover"
    case contain = "contain"
  }

}

internal extension LineTemplate {

  internal func toDict() -> [String: Any] {
    var dict = [String: Any]()
    switch self {
    case .button(let button):
      dict["type"] = "buttons"
      dict["thumbnailImageUrl"] = button.thumbnailImageUrl
      dict["imageAspectRatio"] = button.imageAspectRatio?.rawValue
      dict["imageSize"] = button.imageSize?.rawValue
      dict["imageBackgroundColor"] = button.imageBackgroundColor
      dict["title"] = button.title
      dict["text"] = button.text
      dict["defaultAction"] = button.defaultAction?.toDict()
      dict["actions"] = button.actions.map { $0.toDict() }
    case .confirm(let confirm):
      dict["type"] = "confirm"
      dict["text"] = confirm.text
      dict["actions"] = confirm.actions.map { $0.toDict() }
    case .carousel(let carousel):
      dict["type"] = "carousel"
      dict["columns"] = carousel.columns.map { $0.toDict() }
      dict["imageAspectRatio"] = carousel.imageAspectRatio?.rawValue
      dict["imageSize"] = carousel.imageSize?.rawValue
    case .imageCarousel(let imageCarousel):
      dict["type"] = "image_carousel"
      dict["columns"] = imageCarousel.columns.map { $0.toDict() }
    }
    return dict
  }

}

