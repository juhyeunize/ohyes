package {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.JPEGEncoderOptions;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.net.FileFilter;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.engine.FontWeight;
import flash.utils.ByteArray;

[SWF(width="1280", height="960", backgroundColor="#333333", frameRate="60")]

public class Main extends Sprite {
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

    private var _originCardImageLoader:Loader;
    private var _cardImageSprite:Sprite;

    private var _textStyle:TextStyle;

    private var _cardNumberEditorSprite:Sprite;
    private var _cardNumberMoveIcon:Sprite;
    private var _cardNumberTextField:TextField;
    private var _cardNumberTextFormat:TextFormat;

    private var _cardValidThruEditorSprite:Sprite;
    private var _cardValidThruMoveIcon:Sprite;
    private var _cardValidThruTextField:TextField;
    private var _cardValidThruTextFormat:TextFormat;

    private var _isOpendImage:Boolean = false;
    private var _cardWidth:Number;
    private var _cardHeight:Number;

    private var _fonts:Vector.<String>;

    public function Main() {
        if (stage) {
            init()
        } else {
            this.addEventListener(Event.ADDED_TO_STAGE, init);
        }
    }

    private function init(event:Event = null):void {
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.TOP_LEFT;

        stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.stageWidth) * 0.5;
        stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.stageHeight) * 0.5;

        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

        _fonts = new <String>["ArialBold", "Eyetype1", "Shree", "Prestige"];
        _textStyle = new TextStyle();

        _originCardImageLoader = new Loader();
        _originCardImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeOriginImageLoad);

        _cardImageSprite = new Sprite();
        addChild(_cardImageSprite);

        _cardNumberEditorSprite = new Sprite();
        _cardNumberMoveIcon = new Sprite();
        _cardNumberMoveIcon.graphics.clear();
        _cardNumberMoveIcon.graphics.lineStyle(3, 0x0000FF);
        _cardNumberMoveIcon.graphics.moveTo(0, -8);
        _cardNumberMoveIcon.graphics.lineTo(0, 8);
        _cardNumberMoveIcon.graphics.moveTo(-8, 0);
        _cardNumberMoveIcon.graphics.lineTo(8, 0);
        _cardNumberMoveIcon.addEventListener(MouseEvent.MOUSE_DOWN, downMoveIconHandler);
        _cardNumberMoveIcon.addEventListener(MouseEvent.MOUSE_UP, upMoveIconHandler);

        _cardNumberTextFormat = new TextFormat();
        _cardNumberTextFormat.color = 0x000000;
        _cardNumberTextFormat.size = 60;
//        _cardNumberTextFormat.font = "YouAndI";

        _cardNumberTextField = new TextField();
//        _cardNumberTextField.embedFonts = true;
//        _cardNumberTextField.defaultTextFormat = _cardNumberTextFormat;
        _cardNumberTextField.autoSize = TextFieldAutoSize.LEFT;
//        _cardNumberTextField.type = TextFieldType.INPUT;

        _cardValidThruEditorSprite = new Sprite();
        _cardValidThruMoveIcon = new Sprite();
        _cardValidThruMoveIcon.graphics.clear();
        _cardValidThruMoveIcon.graphics.lineStyle(3, 0x0000FF);
        _cardValidThruMoveIcon.graphics.moveTo(0, -8);
        _cardValidThruMoveIcon.graphics.lineTo(0, 8);
        _cardValidThruMoveIcon.graphics.moveTo(-8, 0);
        _cardValidThruMoveIcon.graphics.lineTo(8, 0);
        _cardValidThruMoveIcon.addEventListener(MouseEvent.MOUSE_DOWN, downValidThruIconHandler);
        _cardValidThruMoveIcon.addEventListener(MouseEvent.MOUSE_UP, upValidThruIconHandler);

        _cardValidThruTextFormat = new TextFormat();
        _cardValidThruTextFormat.color = 0x000000;
        _cardValidThruTextFormat.size = 30;
//        cardValidThruTextFormat.font = "Arial Bold"

        _cardValidThruTextField = new TextField();
        _cardValidThruTextField.embedFonts = true;
//        _cardValidThruTextField.defaultTextFormat = cardValidThruTextFormat;
        _cardValidThruTextField.autoSize = TextFieldAutoSize.LEFT;
        _cardValidThruTextField.type = TextFieldType.INPUT;
    }

    private function keyUpHandler(event:KeyboardEvent):void {


    }

    private function keyDownHandler(event:KeyboardEvent):void {
        trace(event.keyCode);
        switch (event.keyCode) {
            case 79:
                // Open Image (o)
                if (event.ctrlKey) {
                    loadImage();
                }
                break;
            case 71:
                // Generate Card Number (g)
                if (event.ctrlKey) {
                    if (_isOpendImage)
                        generateCardNumber();
                }
                break;
            case 83:
                // Save Generated Image (s)
                if (event.ctrlKey) {
                    if (_isOpendImage)
                            saveGeneratedImage();
                }
                break;
            case 38:
                // Card Number Text Scale Up
                if (_isOpendImage) {
                    if (event.ctrlKey && event.shiftKey)
                        _cardNumberTextField.scaleX = _cardNumberTextField.scaleY += 0.02;
                    else if (event.ctrlKey)
                        _cardNumberTextField.scaleX = _cardNumberTextField.scaleY += 0.1;
                }
                break;
            case 40:
                // Card Number Text Scale Down
                if (_isOpendImage) {
                    if (event.ctrlKey && event.shiftKey)
                        _cardNumberTextField.scaleX = _cardNumberTextField.scaleY -= 0.02;
                    else if (event.ctrlKey)
                        _cardNumberTextField.scaleX = _cardNumberTextField.scaleY -= 0.1;
                }
                break;
            case 37:
                // Valid Thru Number Text Scale Down
                if (_isOpendImage) {
                    if (event.ctrlKey && event.shiftKey)
                            _cardValidThruTextField.scaleX = _cardValidThruTextField.scaleY -= 0.02;
                    else if (event.ctrlKey)
                            _cardValidThruTextField.scaleX = _cardValidThruTextField.scaleY -= 0.1;
                }
                break;
            case 39:
                // Valid Thru Number Text Scale Up
                if (_isOpendImage) {
                    if (event.ctrlKey && event.shiftKey)
                        _cardValidThruTextField.scaleX = _cardValidThruTextField.scaleY += 0.02;
                    else if (event.ctrlKey)
                        _cardValidThruTextField.scaleX = _cardValidThruTextField.scaleY += 0.1;
                }
        }
    }

    private function loadImage():void {
        var fileToOpen:File = new File();
        var imageFileFilter:FileFilter = new FileFilter("Images", "*.jpg;*.png;*.jpeg;*.gif");
        try {
            fileToOpen.browseForOpen("Open Image File", [imageFileFilter]);
            fileToOpen.addEventListener(Event.SELECT, selectedFile);
        } catch (error:Error) {

        }
    }

    private function selectedFile(event:Event):void {
        var file:File = event.target as File;
        openImageFile(file);
    }

    private function openImageFile(file:File):void {
        _originCardImageLoader.load(new URLRequest(file.url));
    }

    private function completeOriginImageLoad(event:Event):void {
        _cardWidth = _originCardImageLoader.content.width;
        _cardHeight = _originCardImageLoader.content.height;
        var cardBitmapData:BitmapData = new BitmapData(_cardWidth, _cardHeight);
        cardBitmapData.draw(_originCardImageLoader);
        var cardBitmap:Bitmap = new Bitmap(cardBitmapData)
        _cardImageSprite.addChild(cardBitmap);

        _cardNumberEditorSprite.addChild(_cardNumberTextField);
        _cardNumberEditorSprite.addChild(_cardNumberMoveIcon);
        _cardImageSprite.addChild(_cardNumberEditorSprite);
        _cardNumberEditorSprite.x = 80;
        _cardNumberEditorSprite.y = 350;

        _cardValidThruEditorSprite.addChild(_cardValidThruTextField);
        _cardValidThruEditorSprite.addChild(_cardValidThruMoveIcon);
        _cardImageSprite.addChild(_cardValidThruEditorSprite);
        _cardValidThruEditorSprite.x = 400;
        _cardValidThruEditorSprite.y = 450;

        _isOpendImage = true;
    }

    private function upMoveIconHandler(event:MouseEvent):void {
        _cardNumberEditorSprite.stopDrag();
    }

    private function downMoveIconHandler(event:MouseEvent):void {
        _cardNumberEditorSprite.startDrag();
    }

    private function upValidThruIconHandler(event:MouseEvent):void {
        _cardValidThruEditorSprite.stopDrag();
    }

    private function downValidThruIconHandler(event:MouseEvent):void {
        _cardValidThruEditorSprite.startDrag();
    }

    private function generateCardNumber():void {
        var cardNumberString:String = "";
        for (var i:int = 0; i < 16; i++) {
            var number:Number = Math.floor(Math.random() * 10);
            cardNumberString += number;
            if (i % 4 == 3 && i != 15) {
                cardNumberString += " ";
            }
        }
//        trace(cardNumberString);
//        _cardNumberTextField.text = cardNumberString;
////        trace(_cardNumberTextFormat.font);
        var font:String = _fonts[Math.floor(Math.random() * _fonts.length)];
//        trace(_fonts[fontIndex])
//        _cardNumberTextFormat.font = font;
//        _cardNumberTextFormat.bold = true;
//        _cardNumberTextField.setTextFormat(_cardNumberTextFormat);

        _cardNumberTextField.styleSheet = _textStyle.cardNumberStyle1;
        var htmlText:String = '<p class="numberStyle1">' + cardNumberString + '</p>';
        trace(htmlText);
        _cardNumberTextField.htmlText = htmlText;

        var monthYearString:String = "";
        var month:Number = Math.floor(Math.random() * 12) + 1;
        var year:Number = Math.floor(Math.random() * 100);
        if (month < 10)
                monthYearString = "0" + month + "/";
        else
                monthYearString = month + "/";

        if (year < 10)
                monthYearString += "0" + year;
        else
                monthYearString += year;

//        trace(monthYearString);
        _cardValidThruTextField.text = monthYearString;
        _cardValidThruTextFormat.font = font;
        _cardValidThruTextField.setTextFormat(_cardValidThruTextFormat);

    }

    private function saveGeneratedImage():void {
        _cardNumberMoveIcon.visible = false;
        _cardValidThruMoveIcon.visible = false;

        var saveImageBitmapData:BitmapData = new BitmapData(_cardWidth, _cardHeight);
        saveImageBitmapData.draw(_cardImageSprite);
        var saveImageByteArray:ByteArray = new ByteArray()
        saveImageBitmapData.encode(new Rectangle(0, 0, _cardWidth, _cardHeight), new JPEGEncoderOptions(100), saveImageByteArray);
        var saveFileStream:FileStream = new FileStream();
        var saveFile:File = new File("/Users/SKP-Juhyeunize/Desktop/checkcard_test/sample01.jpg");
        saveFileStream.open(saveFile, FileMode.WRITE);
        saveFileStream.writeBytes(saveImageByteArray, 0, saveImageByteArray.length);
        saveFileStream.close();

    }
}
}
