//
//  MarkupDiv.swift
//  MarkupEditor
//  Adapted from https://stackoverflow.com/a/38885813/8968411
//
//  Created by Steven Harris on 12/26/23.
//

import Foundation
import MarkupEditor

public protocol HasMarkupDiv {
    var htmlDiv: HtmlDiv { get set }
}

public protocol MarkupDiv: HasMarkupDiv { }

/// The MarkupDiv extension just trampolines to get/set the corresponding HtmlDiv values.
extension MarkupDiv {
    public var id: String {
        get { htmlDiv.id }
        set { htmlDiv.id = newValue }
    }
    public var parentId: String {
        get { htmlDiv.parentId }
        set { htmlDiv.parentId = newValue }
    }
    public var cssClass: String {
        get { htmlDiv.cssClass }
        set { htmlDiv.cssClass = newValue }
    }
    public var attributes: EditableAttributes {
        get { htmlDiv.attributes }
        set { htmlDiv.attributes = newValue }
    }
    public var htmlContents: String {
        get { htmlDiv.htmlContents }
        set { htmlDiv.htmlContents = newValue }
    }
    public var buttonGroup: MarkupButtonGroup? {
        get { htmlDiv.buttonGroup }
        set { htmlDiv.buttonGroup = newValue }
    }
}
