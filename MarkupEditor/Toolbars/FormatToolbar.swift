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
           
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichLogButtonType == "Text" {
              ToolbarTextButton(
               title: "Bold",
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
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichLogButtonType == "Text" {
              ToolbarTextButton(
               title: "Italic",
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
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichLogButtonType == "Text" {
              ToolbarTextButton(
               title: "Subhead",
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
           
           if MarkupEditorView.whichEditor == "Log" && MarkupEditorView.whichLogButtonType == "Text" {
              ToolbarTextButton(
               title: "Move",
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
            
            // Word Count Display
            if MarkupEditorView.whichEditor == "Log" || MarkupEditorView.whichEditor == "LibComp" {
               WordCountDisplay()
                  .padding(.leading, 8)
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

// MARK: - Word Count Display
/// A view that displays the current word count for the WYSIWYG editor
struct WordCountDisplay: View {
    @State private var wordCount: Int = 0
    @ObservedObject private var observedWebView: ObservedWebView = MarkupEditor.observedWebView
    
    // Timer to periodically update word count
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "doc.text")
                .font(.system(size: 10))
            Text("\(wordCount)")
                .fontWeight(.medium)
        }
        .font(.system(size: 12))
        .foregroundColor(Color("Always Yellow"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color("Always Yellow").opacity(0.15))
        .cornerRadius(4)
        .onReceive(timer) { _ in
            updateWordCount()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MarkupContentChanged"))) { _ in
            updateWordCount()
        }
        .onAppear {
            updateWordCount()
        }
    }
    
    private func updateWordCount() {
        guard let webView = observedWebView.selectedWebView else {
            wordCount = 0
            return
        }
        
        webView.getHtml { html in
            guard let htmlText = html else {
                DispatchQueue.main.async {
                    self.wordCount = 0
                }
                return
            }
            
            // Strip HTML tags for accurate word count
            let strippedText = htmlText
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                .replacingOccurrences(of: "&nbsp;", with: " ")
                .replacingOccurrences(of: "&amp;", with: "&")
                .replacingOccurrences(of: "&lt;", with: "<")
                .replacingOccurrences(of: "&gt;", with: ">")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let words = strippedText.split(whereSeparator: { $0.isWhitespace || $0.isNewline })
            
            DispatchQueue.main.async {
                self.wordCount = words.count
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
