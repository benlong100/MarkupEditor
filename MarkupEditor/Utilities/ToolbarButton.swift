//
//  ToolbarButton.swift
//  MarkupEditor
//
//  Created by Steven Harris on 4/5/21.
//  Copyright © 2021 Steven Harris. All rights reserved.
//

import SwiftUI

public struct ToolbarImageButton<Content: View>: View {

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
                .frame(width: MarkupEditor.toolbarStyle.buttonHeight(), height: MarkupEditor.toolbarStyle.buttonHeight())
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
//        .contentShape(RoundedRectangle(cornerRadius: 3))
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

    let title: String
    let action: ()->Void
    let width: CGFloat?
    @Binding var active: Bool
    let activeColor: Color
    
    public var body: some View {
       Button(action: action, label: {
          if MarkupEditorView.whichSkin != "LCARS" {
             Text(title)
                .frame(width: width, height: MarkupEditor.toolbarStyle.buttonHeight())
                .padding(.horizontal, 8)
//                .background(
//                    RoundedRectangle(
//                        cornerRadius: 3,
//                        style: .continuous
//                    )
//                    .stroke(Color.accentColor)
//                    .background(Color(UIColor.systemGray6))
//                )

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
//       .contentShape(RoundedRectangle(cornerRadius: 3))
       .buttonStyle(ToolbarButtonStyle(active: $active, activeColor: activeColor))    }
    
    public init(title: String, action: @escaping ()->Void, width: CGFloat? = nil, active: Binding<Bool> = .constant(false), activeColor: Color = .accentColor) {
        self.title = title
        self.action = action
        self.width = width
        _active = active
        self.activeColor = activeColor
    }
    
}

public struct ToolbarIconButtonStyle: ButtonStyle {
   @Binding var active: Bool
   let activeColor: Color
   
   private func colorAsset(_ name: String, fallback: Color) -> Color {
       guard !name.isEmpty else { return fallback }
       if let uiColor = UIColor(named: name, in: .main, compatibleWith: nil) {
           return Color(uiColor)
       }
       return fallback
   }

   public init(active: Binding<Bool>, activeColor: Color) {
      _active = active
//      self.activeColor = Color(AnsibleButtonSkin.persLogButtonFG)
      self.activeColor = activeColor
   }
   
   @MainActor public func makeBody(configuration: Self.Configuration) -> some View {
      if MarkupEditorView.whichSkin == "Stock Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .foregroundColor(.red)
//            .foregroundColor(
//                active
//                ? Color(.red)
//                : colorAsset(
//                    MarkupEditorView.whichEditor == "Log"
//                        ? AnsibleButtonSkin.persLogIconButtonFG
//                        : AnsibleButtonSkin.libCompIconButtonFG,
//                    fallback: Color(.red)
//                  )
//            )
         //            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.gray))
      } else if MarkupEditorView.whichSkin == "Lean Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Lean Dark Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
            .foregroundColor(active ? Color(.red) : Color(AnsibleButtonSkin.libCompIconButtonFG))
      } else if MarkupEditorView.whichSkin == "Lean Fantasy" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Lean Dark Fantasy" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "Stock Fantasy" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "The Establishment" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "TerminalLog" {
         configuration.label
            .padding(.horizontal)
            .frame(width: 36 , height: 30, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? Color(.red) : Color(MarkupEditorView.whichEditor == "Log" ? AnsibleButtonSkin.persLogIconButtonFG : AnsibleButtonSkin.libCompIconButtonFG))
            .background(active ? Color(AnsibleButtonSkin.libCompIconButtonBGTransparency) : Color(.clear))
      } else if MarkupEditorView.whichSkin == "LCARS" {
         configuration.label
            .frame(width: 90 , height: 36, alignment: .center)
         
         //            .padding(.horizontal)
         //            .padding(.top, 5)
         //            .padding(.bottom, 5)
            .foregroundColor(active ? Color(AnsibleButtonSkin.persLogButtonFG) : activeColor)
         //            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color("Always Red"))
      } else {
              // ✅ IMPORTANT: default fallback so buttons always render
              configuration.label
                  .frame(width: 36, height: 30, alignment: .center)
                  .foregroundColor(active ? .accentColor : activeColor)
          }
   }
}



public struct ToolbarButtonStyle: ButtonStyle {
   
   private func colorAsset(_ name: String, fallback: Color) -> Color {
       guard !name.isEmpty else { return fallback }
       if let uiColor = UIColor(named: name, in: .main, compatibleWith: nil) {
           return Color(uiColor)
       }
       return fallback
   }
   
   @Binding var active: Bool
   let activeColor: Color
   
   public init(active: Binding<Bool>, activeColor: Color) {
      _active = active
//      self.activeColor = Color(AnsibleButtonSkin.persLogButtonFG)
      self.activeColor = activeColor
   }
   
   @MainActor public func makeBody(configuration: Self.Configuration) -> some View {
      if MarkupEditorView.whichSkin == "Stock Science Fiction" {
         
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .frame( height: 18, alignment: .center)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .padding(.vertical, 5)
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))

      } else if MarkupEditorView.whichSkin == "Lean Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .frame( height: 28, alignment: .center)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))
      } else if MarkupEditorView.whichSkin == "Lean Dark Science Fiction" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .frame( height: 28, alignment: .center)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))
      } else if MarkupEditorView.whichSkin == "Stock Fantasy" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 0)
            .padding(.bottom, 0)
            .frame( height: 30, alignment: .center)
            .border(Color.brown, width: 3)
            .font(Font.custom("Trattatello", size: 18))
         //            .kerning(theGlobals.screenOrientation == "Landscape" ? 0 : -1)
            .textCase(.uppercase)
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))
      } else if MarkupEditorView.whichSkin == "Lean Fantasy" || MarkupEditorView.whichSkin == "Lean Dark Fantasy"{
         configuration.label
            .padding(.horizontal)
            .padding(.top, 0)
            .padding(.bottom, 0)
            .frame( height: 30, alignment: .center)
            .font(Font.custom("Trattatello", size: 18))
            .textCase(.uppercase)
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))

      } else if MarkupEditorView.whichSkin == "The Establishment" {
         configuration.label
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 5)
            .frame( height: 30, alignment: .center)
            .font(Font.custom("Inconsolata-Regular", size: 18))
            .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                  fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
            .background(
               Rectangle()
                  .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                            fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))

         // This style is different from the others because I was having trouble with the button background color filling the entire bottom padding area.
      } else if MarkupEditorView.whichSkin == "TerminalLog" {
         configuration.label
             .padding(.horizontal)
             .padding(.top, 5)
             .padding(.bottom, 5)
             .frame( height: 25, alignment: .center)
             .font(Font.custom("Inconsolata-Regular", size: 18))
             .background(
                Rectangle()
                   .fill(active ? colorAsset(AnsibleButtonSkin.logTextButtonBGColorSelected,
                                             fallback: Color(.red)) : colorAsset(AnsibleButtonSkin.logTextButtonBackgroundColor, fallback: Color(.red))))

             .foregroundColor(active ? (colorAsset(AnsibleButtonSkin.logTextButtonHighlightFGColor,
                                                   fallback: Color(.red))) : (colorAsset(AnsibleButtonSkin.persLogButtonFG, fallback: Color(.red))))
//             .background(
//                 GeometryReader { geometry in
//                     (active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color(AnsibleButtonSkin.logTextButtonBackgroundColor))
//                         .frame(height: geometry.size.height - 35) // Adjust the height to exclude the bottom padding
//                         .padding(.bottom, 40) // Push the background up to exclude the bottom padding area
//                 }
//             )
      } else if MarkupEditorView.whichSkin == "LCARS" {
         configuration.label
            .frame(width: 90 , height: 36, alignment: .center)
         //            .padding(.horizontal)
         //            .padding(.top, 5)
         //            .padding(.bottom, 5)
            .foregroundColor(active ? .yellow : Color(AnsibleButtonSkin.persLogButtonFG))
         //            .background(active ? Color(AnsibleButtonSkin.logTextButtonHighlightBGColor) : Color("Always Red"))
      } else {
          configuration.label
              .padding(.horizontal, 8)
              .padding(.vertical, 5)
              .foregroundColor(active ? Color(.systemBackground) : activeColor)
              .background(
                  RoundedRectangle(cornerRadius: 3, style: .continuous)
                      .fill(active ? activeColor : Color(.systemGray6))
              )
              .overlay(
                  RoundedRectangle(cornerRadius: 3, style: .continuous)
                      .stroke(activeColor, lineWidth: 1)
              )
      }
   }
}





public class AnsibleButtonSkin {
   //   static var shared = AnsibleButtonSkin()
   
   // The Personal Log buttons
   public static var persLogButtonFG : String = ""
   public static var persLogIconButtonFG : String = ""
   public static var logTextButtonBackgroundColor : String = ""
   public static var logTextButtonBGColorSelected : String = ""
   public static var logTextButtonDisabledColor : String = ""
   public static var logTextButtonHighlightBGColor : String = ""
   public static var logTextButtonHighlightFGColor : String = ""
   public static var logTextButtonHighlightFont : String = ""
   public static var logTextButtonHighlightFontSize : CGFloat = 0
   public static var logTextButtonHighlightTopPadding : CGFloat = 0
   public static var logTextButtonHighlightBottomPadding : CGFloat = 0
   public static var libCompIconButtonBGTransparency : UIColor  = .black
   public static var libCompIconButtonFG : String = ""
   public static var markupEditorButtonHeight : CGFloat = 30
   public static var markupEditorIconButtonHeight : CGFloat = 30
   public init(
      persLogButtonFG: String = "",
      persLogIconButtonFG: String = "",
      logTextButtonBackgroundColor: String = "",
      logTextButtonBGColorSelected: String = "",
      logTextButtonDisabledColor: String = "",
      logTextButtonHighlightBGColor: String = "",
      logTextButtonHighlightFGColor: String = "",
      logTextButtonHighlightFont: String = "",
      logTextButtonHighlightFontSize: CGFloat = 0,
      logTextButtonHighlightTopPadding: CGFloat = 0,
      logTextButtonHighlightBottomPadding: CGFloat = 0,
      libCompIconButtonBGTransparency: UIColor = .black,
      libCompIconButtonFG: String = "",
      markupEditorButtonHeight: CGFloat = 30,
      markupEditorIconButtonHeight : CGFloat = 30

   ) {
      AnsibleButtonSkin.persLogButtonFG = persLogButtonFG
      AnsibleButtonSkin.persLogIconButtonFG = persLogIconButtonFG
      AnsibleButtonSkin.logTextButtonBackgroundColor = logTextButtonBackgroundColor
      AnsibleButtonSkin.logTextButtonBGColorSelected = logTextButtonBGColorSelected
      AnsibleButtonSkin.logTextButtonDisabledColor = logTextButtonDisabledColor
      AnsibleButtonSkin.logTextButtonHighlightBGColor = logTextButtonHighlightBGColor
      AnsibleButtonSkin.logTextButtonHighlightFGColor = logTextButtonHighlightFGColor
      AnsibleButtonSkin.logTextButtonHighlightFont = logTextButtonHighlightFont
      AnsibleButtonSkin.logTextButtonHighlightFontSize = logTextButtonHighlightFontSize
      AnsibleButtonSkin.logTextButtonHighlightTopPadding = logTextButtonHighlightTopPadding
      AnsibleButtonSkin.logTextButtonHighlightBottomPadding = logTextButtonHighlightBottomPadding
      AnsibleButtonSkin.libCompIconButtonBGTransparency = libCompIconButtonBGTransparency
      AnsibleButtonSkin.libCompIconButtonFG = libCompIconButtonFG
      AnsibleButtonSkin.markupEditorButtonHeight = markupEditorButtonHeight
      AnsibleButtonSkin.markupEditorIconButtonHeight = markupEditorIconButtonHeight
   }
   
}
