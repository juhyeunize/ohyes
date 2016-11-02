/**
 * Created by 1001101 on 2016. 11. 2..
 */
package {
import flash.text.StyleSheet;

public class TextStyle {
    public var cardNumberStyle1:StyleSheet;
    public var cardNumberStyle2:StyleSheet;
    public var cardNumberStyle3:StyleSheet;
    public var cardNumberStyle4:StyleSheet;
    public var cardNumberStyle5:StyleSheet;

    // Fonts
    [Embed(source="../Resources/Arial Bold.ttf", fontName="ArialBold", embedAsCFF="false", mimeType="application/x-font-truetype")]
    static public var ArialBlack:Class;
    [Embed(source="../Resources/Eyetype1.otf", fontName="Eyetype1", embedAsCFF="false", mimeType="application/x-font-truetype")]
    static public var Eyetype1:Class;
    [Embed(source="../Resources/Shree714.ttc", fontName="Shree", embedAsCFF="false", mimeType="application/x-font-truetype")]
    static public var Samgam:Class;
    [Embed(source="../Resources/PrestigeEliteStd-Bd.otf", fontName="Prestige", embedAsCFF="false", mimeType="application/x-font-truetype")]
    static public var Prestige:Class;
//    [Embed(source="../Resources/YouandiModernTR.ttf", fontName="YouAndI", embedAsCFF="false", mimeType="application/x-font-truetype")]
//    static public var YouAndI:Class;
    public function TextStyle() {
        var styleObj1:Object = new Object();
        styleObj1.fontFamily = "ArialBold";
        styleObj1.color = "#000000";
        styleObj1.fontSize = "60px";
        cardNumberStyle1 = new StyleSheet();
        cardNumberStyle1.setStyle(".numberStyle1", styleObj1);

        var styleObj2:Object = new Object();
        styleObj2.fontFamily = "Eyetype1";
        styleObj2.color = "#000000";
        styleObj2.fontSize = "60px";
        styleObj2.letterSpacing = "-5px";
//        cardNumberStyle2 = new StyleSheet();
        cardNumberStyle1.setStyle(".numberStyle2", styleObj2);

        var styleObj3:Object = new Object();
        styleObj3.fontFamily = "Eyetype1";
        styleObj3.color = "#000000";
        styleObj3.fontSize = "60px";
        styleObj3.letterSpacing = "2px";
//        cardNumberStyle3 = new StyleSheet();
        cardNumberStyle1.setStyle(".numberStyle3", styleObj3);

        var styleObj4:Object = new Object();
        styleObj4.fontFamily = "Shree";
        styleObj4.color = "#000000";
        styleObj4.fontSize = "60px";
        styleObj4.fontWeight = "Bold";
//        cardNumberStyle4 = new StyleSheet();
        cardNumberStyle1.setStyle(".numberStyle4", styleObj4);

        var styleObj5:Object = new Object();
        styleObj5.fontFamily = "Prestige";
        styleObj5.color = "#000000";
        styleObj5.fontSize = "60px";
        cardNumberStyle1.setStyle(".numberStyle5", styleObj5);



    }
}
}
