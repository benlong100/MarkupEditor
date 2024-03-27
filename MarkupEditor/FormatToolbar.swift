//
//  FormatToolbar.swift
//  MarkupEditor
//
//  Created by Steven Harris on 4/7/21.
//  Copyright © 2021 Steven Harris. All rights reserved.
//

import SwiftUI

public struct FormatToolbar: View {
    @ObservedObject private var observedWebView: ObservedWebView = MarkupEditor.observedWebView
    @ObservedObject private var selectionState: SelectionState = MarkupEditor.selectionState
    private let contents: FormatContents = MarkupEditor.toolbarContents.formatContents
    @State private var hoverLabel: Text = Text("Text Format")

    public init() {}

    public var body: some View {
        LabeledToolbar(label: hoverLabel) {
           
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichSkin != "The Establishment" {
              ToolbarTextButton(
               title: "BOLD",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  observedWebView.selectedWebView?.bold() },
               active: $selectionState.bold
              )
           } else {
              ToolbarImageButton(
               systemName: "bold",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  observedWebView.selectedWebView?.bold()
               },
               active: $selectionState.bold,
               onHover: { over in hoverLabel = Text(over ? "Bold" : "Text Format") }
              )
           }
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichSkin != "The Establishment" {
              ToolbarTextButton(
               title: "ITALIC",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  observedWebView.selectedWebView?.italic()
               },
               active: $selectionState.italic
              )
           } else {
              ToolbarImageButton (
               systemName: "italic",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  
                  observedWebView.selectedWebView?.italic()
               },
               active: $selectionState.italic,
               onHover: { over in hoverLabel = Text(over ? "Italic" : "Text Format") }
              )
           }
           
//           if MarkupEditorView.whichEditor == "Log" {
//              ToolbarTextButton(
//               title: "UNDERLINE",
//               action: { observedWebView.selectedWebView?.underline()}
//              )
//           } else {
//              ToolbarImageButton(
//               systemName: "underline",
//               action: { observedWebView.selectedWebView?.underline() },
//               active: $selectionState.underline,
//               onHover: { over in hoverLabel = Text(over ? "Underline" : "Text Format") }
//              )
//           }
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichSkin != "The Establishment" {
              ToolbarTextButton(
               title: "SUBHEAD",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  
                  observedWebView.selectedWebView?.replaceStyle(selectionState.style, with: StyleContext.H1)
               }
              )
           } else {
              ToolbarImageButton(
               systemName: "character.magnify",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  
                  observedWebView.selectedWebView?.replaceStyle(selectionState.style, with: StyleContext.H1)
               },
               active: $selectionState.underline,
               onHover: { over in hoverLabel = Text(over ? "Subhead" : "Text Format") }
              )
           }
           
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichSkin != "The Establishment" {
              ToolbarTextButton(
               title: "MOVE",
               action: {
                  if MarkupEditorView.whichSkin == "LCARS" {
//                     play(sound: "computerbeep_15.mp3")
                  }
                  observedWebView.selectedWebView?.code()
               },
               active: $selectionState.code
              )
           } else {
                ToolbarImageButton(
                    systemName: "figure.walk",
                    action: { observedWebView.selectedWebView?.code() },
                    active: $selectionState.code,
                    onHover: { over in hoverLabel = Text(over ? "Code" : "Text Format") }
                )
            }
            if contents.strike {
                ToolbarImageButton(
                    systemName: "strikethrough",
                    action: { observedWebView.selectedWebView?.strike() },
                    active: $selectionState.strike,
                    onHover: { over in hoverLabel = Text(over ? "Strikethrough" : "Text Format") }
                )
            }
            if contents.subSuper {
                ToolbarImageButton(
                    systemName: "textformat.subscript",
                    action: { observedWebView.selectedWebView?.subscriptText() },
                    active: $selectionState.sub,
                    onHover: { over in hoverLabel = Text(over ? "Subscript" : "Text Format") }
                )
                ToolbarImageButton(
                    systemName: "textformat.superscript",
                    action: { observedWebView.selectedWebView?.superscript() },
                    active: $selectionState.sup,
                    onHover: { over in hoverLabel = Text(over ? "Superscript" : "Text Format") }
                )
            }
        }
    }
}
//
//struct FormatToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                FormatToolbar()
//                    .environmentObject(ToolbarStyle.compact)
//                Spacer()
//            }
//            HStack {
//                FormatToolbar()
//                    .environmentObject(ToolbarStyle.labeled)
//                Spacer()
//            }
//            Spacer()
//        }
//    }
//}
