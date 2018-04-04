// All material copyright ESRI, All Rights Reserved, unless otherwise specified.
// See http://js.arcgis.com/3.15/esri/copyright.txt and http://www.arcgis.com/apps/webappbuilder/copyright.txt for details.

require({cache:{"url:widgets/LayerList/PopupMenu.html":'\x3cdiv\x3e\r\n  \x3cdiv class\x3d"popup-menu-transparency-body" data-dojo-attach-point\x3d"transparencyDiv" data-dojo-attach-event\x3d"onclick:_onTransparencyDivClick" \x3e\r\n    \x3cdiv class\x3d"label"\x3e\r\n      \x3cdiv class\x3d"label-left jimu-float-leading"\x3e${nls.itemOpaque}\x3c/div\x3e\r\n      \x3cdiv class\x3d"label-right jimu-float-trailing"\x3e${nls.itemTransparent}\x3c/div\x3e\r\n    \x3c/div\x3e\r\n    \x3cdiv data-dojo-attach-point\x3d"transparencyBody"\x3e \r\n      \x3col data-dojo-attach-point\x3d"transparencyRule" class\x3d"transparency-rule"\x3e \x3c/ol\x3e\r\n    \x3c/div\x3e\r\n  \x3c/div\x3e\r\n\x3cdiv\x3e\r\n'}});
define("dojo/_base/declare dojo/_base/array dojo/_base/html dojo/_base/lang dojo/query dojo/Deferred jimu/dijit/DropMenu dijit/_TemplatedMixin dijit/form/HorizontalSlider dijit/form/HorizontalRuleLabels dojo/text!./PopupMenu.html dojo/dom-style ./NlsStrings ./PopupMenuInfo".split(" "),function(k,g,b,d,f,l,m,n,p,q,r,e,t,u){return k([m,n],{templateString:r,popupMenuInfo:null,loading:null,_deniedItems:null,_deniedItemsFromConfig:null,_layerInfo:null,constructor:function(){this.nls=t.value},postCreate:function(){this.inherited(arguments);
this._initDeniedItems();this.loading=b.create("div",{"class":"popup-menu-loading"},this.popupMenuNode)},_initDeniedItems:function(){var a=[],b={ZoomTo:"zoomto",Transparency:"transparency",EnableOrDisablePopup:"controlPopup",MoveupOrMovedown:"moveup movedown",OpenAttributeTable:"table",DescriptionOrShowItemDetailsOrDownload:"url"};this._deniedItems=[];this._deniedItemsFromConfig=[];for(var c in this._config.contextMenu)this._config.contextMenu.hasOwnProperty(c)&&"function"!==typeof this._config.contextMenu[c]&&
!1===this._config.contextMenu[c]&&(a=a.concat(b[c].split(" ")));g.forEach(a,d.hitch(this,function(a){this._deniedItemsFromConfig.push({key:a,denyType:"hidden"})}))},_getDropMenuPosition:function(){return{top:"40px",right:"0px",zIndex:1}},_getTransNodePosition:function(){return{top:"28px",right:"2px"}},_onBtnClick:function(){},_refresh:function(){this._denyItems();this._changeItemsUI()},_denyItems:function(){var a=f("[class~\x3d'menu-item-identification']",this.dropMenuNode);a.forEach(function(a){b.removeClass(a,
"menu-item-dissable");b.removeClass(a,"menu-item-hidden")},this);b.removeClass(this.dropMenuNode,"no-border");g.forEach(this._deniedItems,function(a){var c=f("div[itemId\x3d'"+a.key+"']",this.dropMenuNode)[0];c&&("disable"===a.denyType?(b.addClass(c,"menu-item-dissable"),"url"===a.key&&f(".menu-item-description",c).forEach(function(a){b.setAttr(a,"href","#");b.removeAttr(a,"target")})):b.addClass(c,"menu-item-hidden"))},this);for(var h=-1,c=0;c<a.length;c++)b.hasClass(a[c],"menu-item-line")&&(-1===
h||b.hasClass(a[h],"menu-item-line"))&&b.addClass(a[c],"menu-item-hidden"),b.hasClass(a[c],"menu-item-hidden")||(h=c);a=g.filter(a,function(a){return!b.hasClass(a,"menu-item-hidden")});0===a.length?b.addClass(this.dropMenuNode,"no-border"):(b.removeClass(this.dropMenuNode,"no-border"),b.hasClass(a[a.length-1],"menu-item-line")&&b.addClass(a[a.length-1],"menu-item-hidden"))},_changeItemsUI:function(){var a=f("[itemid\x3dcontrolPopup]",this.dropMenuNode)[0];a&&this._layerInfo.controlPopupInfo&&(this._layerInfo.controlPopupInfo.enablePopup?
b.setAttr(a,"innerHTML",this.nls.removePopup):b.setAttr(a,"innerHTML",this.nls.enablePopup));(a=f("[itemid\x3dcontrolLabels]",this.dropMenuNode)[0])&&this._layerInfo.canShowLabel()&&(this._layerInfo.isShowLabels()?b.setAttr(a,"innerHTML",this.nls.hideLables):b.setAttr(a,"innerHTML",this.nls.showLabels))},_switchLoadingState:function(a){a?b.setStyle(this.loading,"display","block"):b.setStyle(this.loading,"display","none")},selectItem:function(a,b){for(var c=!1,d=0;d<this._deniedItems.length;d++)if(this._deniedItems[d].key===
a.key){c=!0;break}c||this.emit("onMenuClick",a);b.stopPropagation(b)},openDropMenu:function(){var a=d.hitch(this,this.inherited,arguments),b=new l;this._switchLoadingState(!0);this.dropMenuNode?b.resolve(this.popupMenuInfo):u.create(this._layerInfo,this.layerListWidget).then(d.hitch(this,function(a){this.items=a.getDisplayItems();this.popupMenuInfo=a;this._createDropMenuNode();b.resolve(this.popupMenuInfo)}));b.then(d.hitch(this,function(){this.popupMenuInfo.getDeniedItems().then(d.hitch(this,function(b){this._deniedItems=
this._deniedItemsFromConfig.concat(b);this._refresh();a(arguments);this._switchLoadingState(!1)}),d.hitch(this,function(){this._switchLoadingState(!1)}))}),d.hitch(this,function(){this._switchLoadingState(!1)}))},closeDropMenu:function(){this.inherited(arguments);this.hideTransNode()},_onTransparencyDivClick:function(a){a.stopPropagation()},showTransNode:function(a){this.transHorizSlider||(this._createTransparencyWidget(),this.transHorizSlider.set("value",1-a));e.set(this.transparencyDiv,"top",this._getTransNodePosition().top);
isRTL?e.set(this.transparencyDiv,"left",this._getTransNodePosition().right):e.set(this.transparencyDiv,"right",this._getTransNodePosition().right);e.set(this.transparencyDiv,"display","block")},hideTransNode:function(){e.set(this.transparencyDiv,"display","none")},_createTransparencyWidget:function(){this.transHorizSlider=new p({minimum:0,maximum:1,intermediateChanges:!0},this.transparencyBody);this.own(this.transHorizSlider.on("change",d.hitch(this,function(a){this.emit("onMenuClick",{key:"transparencyChanged"},
{newTransValue:a})})));new q({container:"bottomDecoration"},this.transparencyRule)},hide:function(){e.set(this.domNode,"display","none")},show:function(){e.set(this.domNode,"display","block")}})});