// All material copyright ESRI, All Rights Reserved, unless otherwise specified.
// See http://js.arcgis.com/3.15/esri/copyright.txt and http://www.arcgis.com/apps/webappbuilder/copyright.txt for details.
//>>built
define("dojo/_base/declare dojo/on dojo/_base/lang ./_SeriesStyleItem dojo/Evented dijit/_WidgetBase dijit/_TemplatedMixin dijit/_WidgetsInTemplateMixin".split(" "),function(c,e,f,g,h,k,l,m){return c([k,l,m,h],{baseClass:"infographic-series-styles",templateString:'\x3cdiv\x3e\x3cdiv class\x3d"field-style-list"data-dojo-attach-point\x3d"fieldStyleList"\x3e\x3cdiv\x3e\x3c/div\x3e',constructor:function(){this.inherited(arguments);this.cacheDijits=[]},postCreate:function(){this.inherited(arguments);this.setConfig(this.config)},
_clear:function(){this.cacheDijits&&Array.isArray(this.cacheDijits)&&(this.cacheDijits.forEach(function(a){a.dijit.destroy()}),this.cacheDijits=[])},_classificationConfig:function(a){var b={destroyedDijits:[],updatedConfig:[],newAddedConfig:[]},d=[],c=this.cacheDijits.map(function(a){return a.name});a.forEach(function(a){0>c.indexOf(a.name)?b.newAddedConfig.push(a):(d.push(a.name),b.updatedConfig.push(a))});b.destroyedDijits=this.cacheDijits.filter(function(a){return 0>d.indexOf(a.name)});return b},
updateConfig:function(a){a=this._classificationConfig(a);a.newAddedConfig.forEach(function(a){this._addNewItem(a)}.bind(this));a.updatedConfig.forEach(function(a){this._updateItem(a)}.bind(this));a.destroyedDijits.forEach(function(a){this._destroyItem(a)}.bind(this));this._setOpacityDisplay()},setConfig:function(a){a&&Array.isArray(a)&&(this._clear(),a.forEach(function(a){this._addNewItem(a)}.bind(this)),this._setOpacityDisplay())},_destroyItem:function(a){this.cacheDijits=this.cacheDijits.filter(function(b){return b.name!==
a.name});a.dijit&&"undefined"!==typeof a.dijit.destroy&&a.dijit.destroy()},_updateItem:function(a){this.cacheDijits.forEach(function(b){b.name===a.name&&b.dijit.setConfig(a)})},_addNewItem:function(a){var b=null,b=new g({option:{showText:!0,colorSingleMode:!0,showOpacity:!!this.showOpacity,opacity:{min:0,max:10,step:1},config:a}});b.placeAt(this.fieldStyleList,"last");this.own(e(b,"change",f.hitch(this,function(){this._onChange()})));this.cacheDijits.push({name:a.name,dijit:b})},_onChange:function(){var a=
this.getConfig();this.emit("change",a)},setOpacityDisplay:function(a){this._showOpacity=a},_setOpacityDisplay:function(){this.cacheDijits.forEach(function(a){a.dijit.setOpacityDisplay(this._showOpacity)}.bind(this))},getConfig:function(){return!this.cacheDijits||0>=this.cacheDijits.length?[]:this.cacheDijits.map(function(a){return a.dijit.getConfig()})}})});