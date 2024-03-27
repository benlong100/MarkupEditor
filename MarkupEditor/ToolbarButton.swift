//
//  ToolbarButton.swift
//  MarkupEditor
//
//  Created by Steven Harris on 4/5/21.
//  Copyright © 2021 Steven Harris. All rights reserved.
//

import SwiftUI
//import Subsonic
/// A square button typically used with a system image in the toolbar.
///
/// These RoundedRect buttons show text and outline in activeColor (.accentColor by default), with the
/// backgroundColor of UIColor.systemBackground. When active, the text and background switch.
public struct ToolbarImageButton<Content: View>: View {
   private var toolbarStyle: ToolbarStyle = MarkupEditor.toolbarStyle
   private let image: Content
   private let systemName: String?
   private let action: ()->Void
   @Binding private var active: Bool
   private let activeColor: Color
   private let onHover: ((Bool)->Void)?
   
   public var body: some View {
      Button(action: action, label: {
         if MarkupEditorView.whichSkin != "LCARS" {
            label()
               .frame(width: toolbarStyle.buttonHeight(), height: toolbarStyle.buttonHeight())
         } else {
            ZStack {
               Capsule()
                  .foregroundColor(.red)
               HStack {
                  Spacer()
                  Text(systemNameToButtonName(systemName: systemName!))
                     .font(Font.custom("Futura-CondensedMedium", size: 18))
                     .padding(.top, 9)
                     .padding(.trailing, 13)
               }
            }
         }
      })
      .onHover { over in onHover?(over) }
      // For MacOS buttons (Optimized Interface for Mac), specifying .contentShape
      // fixes some flaky problems in surrounding SwiftUI views that are presented
      // below this one, altho AFAICT not in ones adjacent horizontally.
      // Ref: https://stackoverflow.com/a/67377002/8968411
      .contentShape(RoundedRectangle(cornerRadius: 3))
      .buttonStyle(ToolbarIconButtonStyle(active: $active, activeColor: activeColor))
   }
   
   /// Initialize a button using content. See the extension where Content == EmptyView for the systemName style initialization.
   public init(action: @escaping ()->Void, active: Binding<Bool> = .constant(false), activeColor: Color = .accentColor, onHover: ((Bool)->Void)? = nil, @ViewBuilder content: ()->Content) {
      self.systemName = nil
      self.image = content()
      self.action = action
      _active = active
      self.activeColor = activeColor
      self.onHover = onHover
   }
   
   private func systemNameToButtonName(systemName: String) -> String {
      switch systemName {
      case "arrow.uturn.backward":
         return "UNDO"
      case "arrow.uturn.forward" :
         return "REDO"
      case "figure.walk" :
         return "MOVE"
      case "underline" :
         return "UNDERLINE"
      case "italic" :
         return "ITALIC"
      case "bold" :
         return "BOLD"
         
      default:
         return "BUTTON"
      }
   }
   
   private func label() -> AnyView {
      // Return either the image derived from content or the properly-sized systemName image based on style
      if systemName == nil {
         return AnyView(image)
      } else {
         return AnyView(Image(systemName: systemName!).imageScale(.large))
      }
   }
   
}

extension ToolbarImageButton where Content == EmptyView {
   
   /// Initialize a button using a systemImage which will override content, even if passed-in. Intended for use without a content block.
   public init(systemName: String, action: @escaping ()->Void, active: Binding<Bool> = .constant(false), activeColor: Color = .accentColor, onHover: ((Bool)->Void)? = nil, @ViewBuilder content: ()->Content = { EmptyView() }) {
      self.systemName = systemName
      self.image = content()
      self.action = action
      _active = active
      self.activeColor = activeColor
      self.onHover = onHover
   }
   
}

public struct ToolbarTextButton: View {
   var toolbarStyle: ToolbarStyle = MarkupEditor.toolbarStyle
   let title: String
   let action: ()->Void
   let width: CGFloat?
   @Binding var active: Bool
   let activeColor: Color
   
   public var body: some View {
      Button(action: action, label: {
         if MarkupEditorView.whichSkin != "LCARS" {
            Text(title)
         } else {
            // THESE ARE THE LCARS BUTTONS
            ZStack {
               Capsule()
                  .foregroundColor(.red)
               HStack {
                  Spacer()
                  Text(title)
                     .font(Font.custom("Futura-CondensedMedium", size: 18))
                     .padding(.top, 9)
                     .padding(.trailing, 13)
               }
            }
         }
         //                .frame(width: width, height: toolbarStyle.buttonHeight())
         //                .padding(.horizontal, 8)
         //                .background(
         //                    RoundedRectangle(
         //                        cornerRadius: 3,
         //                        style: .continuous
         //                    )
         //                    .stroke(Color.accentColor)
         //                    .background(Color(UIColor.systemGray6))
         //                )
      })
      //        .contentShape(RoundedRectangle(cornerRadius: 3))
      .buttonStyle(ToolbarButtonStyle(active: $active, activeColor: activeColor))
   }
   
   public init(title: String, action: @escaping ()->Void, width: CGFloat? = nil, active: Binding<Bool> = .constant(false), activeColor: Color = .accentColor) {
      self.title = title
      self.action = action
      self.width = width
      _active = active
      self.activeColor = activeColor
   }
   
}

public struct ToolbarIconButtonStyle: ButtonStyle {
   //    @Binding var active: Bool
   //    let activeColor: Color
   //
   //    public init(active: Binding<Bool>, activeColor: Color) {
   //        _active = active
   //        self.activeColor = activeColor
   //    }
   //
   //    public func makeBody(configuration: Self.Configuration) -> some View {
   //        configuration.label
   //            .cornerRadius(3)
   //            .foregroundColor(active ? Color(UIColor.systemBackground) : activeColor)
   //            .overlay(
   //                RoundedRectangle(
   //                    cornerRadius: 3,
   //                    style: .continuous
   //                )
   //                .stroke(Color.accentColor)
   //            )
   //            .background(
   //                RoundedRectangle(
   //                    cornerRadius: 3,
   //                    style: .continuous
   //                )
   //                .fill(active ? activeColor: Color.clear)
   //            )
   //    }
   @Binding var active: Bool
   let activeColor: Color
   
   public init(active: Binding<Bool>, activeColor: Color) {
      _active = active
      self.activeColor = Color(AnsibleButtonSkin.persLogButtonFG)
   }
   
   public func makeBody(configuration: Self.Configuration) -> some View {
      if MarkupEditorView.whichSkin == "Stock Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
         //            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.gray))
      } else if MarkupEditorView.whichSkin == "Lean Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Lean Dark Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
         //            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Lean Fantasy" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Lean Dark Fantasy" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Stock Fantasy" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.libCompIconButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "The Establishment" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.libCompIconButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "TerminalLog" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.libCompIconButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBG) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "LCARS" {
         configuration.label
            .frame(width: 90 , height: 36, alignment: .center)
         
         //            .padding(.horizontal)
         //            .padding(.top, 5)
         //            .padding(.bottom, 5)
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
         //            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color("Always Red"))
      }
   }
}



public struct ToolbarButtonStyle: ButtonStyle {
   //    @Binding var active: Bool
   //    let activeColor: Color
   //
   //    public init(active: Binding<Bool>, activeColor: Color) {
   //        _active = active
   //        self.activeColor = activeColor
   //    }
   //
   //    public func makeBody(configuration: Self.Configuration) -> some View {
   //        configuration.label
   //            .cornerRadius(3)
   //            .foregroundColor(active ? Color(UIColor.systemBackground) : activeColor)
   //            .overlay(
   //                RoundedRectangle(
   //                    cornerRadius: 3,
   //                    style: .continuous
   //                )
   //                .stroke(Color.accentColor)
   //            )
   //            .background(
   //                RoundedRectangle(
   //                    cornerRadius: 3,
   //                    style: .continuous
   //                )
   //                .fill(active ? activeColor: Color.clear)
   //            )
   //    }
   @Binding var active: Bool
   let activeColor: Color
   
   public init(active: Binding<Bool>, activeColor: Color) {
      _active = active
      self.activeColor = Color(AnsibleButtonSkin.persLogButtonFG)
   }
   
   public func makeBody(configuration: Self.Configuration) -> some View {
      if MarkupEditorView.whichSkin == "Stock Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
      } else if MarkupEditorView.whichSkin == "Lean Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
      } else if MarkupEditorView.whichSkin == "Lean Dark Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
      } else if MarkupEditorView.whichSkin == "Stock Fantasy" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 0)
            .padding(.bottom, 0)
            .border(Color.brown, width: 3)
            .font(Font.custom("Trattatello", size: 18))
         //            .kerning(theGlobals.screenOrientation == "Landscape" ? 0 : -1)
            .textCase(.uppercase)
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
      } else if MarkupEditorView.whichSkin == "Lean Fantasy" || MarkupEditorView.whichSkin == "Lean Dark Fantasy"{
         configuration.label
            .padding(.horizontal)
            .padding(.top, 0)
            .padding(.bottom, 0)
            .font(Font.custom("Trattatello", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
      } else if MarkupEditorView.whichSkin == "The Establishment" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
         
         // This style is different from the others because I was having trouble with the button background color filling the entire bottom padding area.
      } else if MarkupEditorView.whichSkin == "TerminalLog" {
         configuration.label
             .padding(.horizontal)
             .padding(.top, 5)
             .padding(.bottom, 35)
             .font(Font.custom("Inconsolata-Regular", size: 18))
             .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
             .background(
                 GeometryReader { geometry in
                     (active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
                         .frame(height: geometry.size.height - 35) // Adjust the height to exclude the bottom padding
                         .padding(.bottom, 40) // Push the background up to exclude the bottom padding area
                 }
             )
      } else if MarkupEditorView.whichSkin == "LCARS" {
         configuration.label
            .frame(width: 90 , height: 36, alignment: .center)
         //            .padding(.horizontal)
         //            .padding(.top, 5)
         //            .padding(.bottom, 5)
            .foregroundColor(active ? .yellow : Color(AnsibleButtonSkin.persLogButtonFG))
         //            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color("Always Red"))
      }
   }
}





public class AnsibleButtonSkin {
   //   static var shared = AnsibleButtonSkin()
   
   // The Personal Log buttons
   public static var persLogButtonFG : String = ""
   public static var logTextButtonBackgroundColor : String = ""
   public static var logTextButtonBGColorSelected : String = ""
   public static var logTextButtonDisabledColor : String = ""
   public static var logTextButtonHighlightBGColor : String = ""
   public static var logTextButtonHighlightFGColor : String = ""
   public static var logTextButtonHighlightFont : String = ""
   public static var logTextButtonHighlightFontSize : CGFloat = 0
   public static var logTextButtonHighlightTopPadding : CGFloat = 0
   public static var logTextButtonHighlightBottomPadding : CGFloat = 0
   public static var libCompIconButtonBG : UIColor  = .black
   public static var libCompIconButtonFG : String = ""
   public init(
      persLogButtonFG: String = "",
      logTextButtonBackgroundColor: String = "",
      logTextButtonBGColorSelected: String = "",
      logTextButtonDisabledColor: String = "",
      logTextButtonHighlightBGColor: String = "",
      logTextButtonHighlightFGColor: String = "",
      logTextButtonHighlightFont: String = "",
      logTextButtonHighlightFontSize: CGFloat = 0,
      logTextButtonHighlightTopPadding: CGFloat = 0,
      logTextButtonHighlightBottomPadding: CGFloat = 0,
      libCompIconButtonBG: UIColor = .black,
      libCompIconButtonFG: String = ""
   ) {
      AnsibleButtonSkin.persLogButtonFG = persLogButtonFG
      AnsibleButtonSkin.logTextButtonBackgroundColor = logTextButtonBackgroundColor
      AnsibleButtonSkin.logTextButtonBGColorSelected = logTextButtonBGColorSelected
      AnsibleButtonSkin.logTextButtonDisabledColor = logTextButtonDisabledColor
      AnsibleButtonSkin.logTextButtonHighlightBGColor = logTextButtonHighlightBGColor
      AnsibleButtonSkin.logTextButtonHighlightFGColor = logTextButtonHighlightFGColor
      AnsibleButtonSkin.logTextButtonHighlightFont = logTextButtonHighlightFont
      AnsibleButtonSkin.logTextButtonHighlightFontSize = logTextButtonHighlightFontSize
      AnsibleButtonSkin.logTextButtonHighlightTopPadding = logTextButtonHighlightTopPadding
      AnsibleButtonSkin.logTextButtonHighlightBottomPadding = logTextButtonHighlightBottomPadding
      AnsibleButtonSkin.libCompIconButtonBG = libCompIconButtonBG
      AnsibleButtonSkin.libCompIconButtonFG = libCompIconButtonFG
   }
   
}
