___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "EEC dataLayer Builder for GA4",
  "categories": [
    "ANALYTICS",
    "UTILITY",
    "TAG_MANAGEMENT"
  ],
  "description": "This original template converts existing Enhanced E-commerce events from the “old” version of Google Analytics (Universal Analytics) to the new Google Analytics 4 E-commerce events",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "selectReturnValue",
    "displayName": "Mode",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "event_name",
        "displayValue": "Event Name"
      },
      {
        "value": "items",
        "displayValue": "Items"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "event_name",
    "alwaysInSummary": true,
    "help": "Select the variable mode"
  },
  {
    "type": "GROUP",
    "name": "checkoutEvents",
    "displayName": "Checkout Events",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "beginCheckoutStep",
        "displayName": "begin_checkout",
        "simpleValueType": true,
        "defaultValue": 1,
        "canBeEmptyString": true,
        "help": "Enter the checkout step for the event \u003cb\u003ebegin_checkout\u003c/b\u003e. \u003cbr\u003eDefault 1",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "(^[0-9]+$|^$)"
            ]
          }
        ],
        "valueHint": "",
        "notSetText": "",
        "alwaysInSummary": true
      },
      {
        "type": "TEXT",
        "name": "addShippingInfoStep",
        "displayName": "add_shipping_info",
        "simpleValueType": true,
        "defaultValue": 2,
        "canBeEmptyString": true,
        "help": "Enter the checkout step for the event \u003cb\u003eadd_shipping_info\u003c/b\u003e. \u003cbr\u003eDefault 2",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "(^[0-9]+$|^$)"
            ]
          }
        ],
        "valueHint": "",
        "notSetText": "",
        "alwaysInSummary": true
      },
      {
        "type": "TEXT",
        "name": "addPaymentInfoStep",
        "displayName": "add_payment_info",
        "simpleValueType": true,
        "defaultValue": 3,
        "canBeEmptyString": true,
        "help": "Enter the checkout step for the event \u003cb\u003eadd_payment_info\u003c/b\u003e. \u003cbr\u003eDefault 3",
        "valueValidators": [
          {
            "type": "REGEX",
            "args": [
              "(^[0-9]+$|^$)"
            ]
          }
        ],
        "valueHint": "",
        "notSetText": "",
        "alwaysInSummary": true
      },
      {
        "type": "GROUP",
        "name": "groupViewCart",
        "displayName": "View Cart Event",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "tickViewCart",
            "checkboxText": "Track view_cart",
            "simpleValueType": true
          },
          {
            "type": "TEXT",
            "name": "viewCartStep",
            "displayName": "view_cart",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "tickViewCart",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "canBeEmptyString": true,
            "valueValidators": [
              {
                "type": "POSITIVE_NUMBER"
              }
            ],
            "help": "Enter the checkout step for the event \u003cb\u003eview_cart\u003c/b\u003e. \u003cbr\u003eDefault disabled",
            "notSetText": "",
            "alwaysInSummary": false
          }
        ]
      }
    ],
    "help": "Define the checkout step numbers for the GA4 event \u003cb\u003eview_cart\u003c/b\u003e, \u003cb\u003ebegin_checkout\u003c/b\u003e, \u003cb\u003eadd_shipping_info\u003c/b\u003e and \u003cb\u003eadd_payment_info\u003c/b\u003e.",
    "enablingConditions": [
      {
        "paramName": "selectReturnValue",
        "paramValue": "event_name",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "defaultCurrency",
    "displayName": "Default Currency value",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "defaultCurrencyValue",
        "displayName": "Default Currency",
        "simpleValueType": true,
        "help": "Enter the default value to use for the Currency parameter, if it\u0027s not found in the dataLayer \"ecommerce.currencyCode\" path"
      }
    ],
    "help": "Enter the default value to use for the Currency parameter, if it\u0027s not found in the dataLayer",
    "enablingConditions": [
      {
        "paramName": "selectReturnValue",
        "paramValue": "items",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const makeTableMap = require('makeTableMap');
const Math = require('Math');
const queryPermission = require('queryPermission');
const copyFromWindow = require('copyFromWindow');
const logToConsole = require('logToConsole');
const copyFromDataLayer = require('copyFromDataLayer');
const setInWindow = require('setInWindow');
const makeInteger = require('makeInteger');

const merge = function() {
  const obj = {},
        il = arguments.length;
  let a = 0,
      key;
  for (; a < il; a++) {
    for (key in arguments[a]) {
      if (arguments[a].hasOwnProperty(key)) {
        obj[key] = arguments[a][key];
      }
    }
  }
  return obj;
};
const parseDimensionsMetrics = function(obj, item) {
  for (var cd in obj) {
    if (obj.hasOwnProperty(cd)) {
      if (cd.match("^dimension[0-9]+")) {
        item[cd] = obj[cd];
      }
    }
  }
  for (var cm in obj) {
    if (obj.hasOwnProperty(cm)) {
      if (cm.match("^metric[0-9]+")) {
        item[cm] = obj[cm];
      }
    }
  }
  return item;
};
const round = function(price){
  return Math.round(price * 100) / 100;
};

let dLayer = copyFromDataLayer('ecommerce', 1), 
    ecommerce, 
    i, 
    currencyValue,
    returnMode = data.selectReturnValue,
    view_cart_step = data.viewCartStep,
    begin_checkout_step = data.beginCheckoutStep,
    add_shipping_info_step = data.addShippingInfoStep,
    add_payment_info_step = data.addPaymentInfoStep,
    default_currency_value = data.defaultCurrencyValue,
    eventName = '',
    items = [];

ecommerce = dLayer;
if(ecommerce === undefined){
  return '';
}

if(ecommerce.hasOwnProperty('currencyCode')){
  currencyValue = ecommerce.currencyCode;
}
else{
  currencyValue = default_currency_value;
}

if(returnMode == 'items'){
  if(ecommerce.hasOwnProperty('items')){
    return ecommerce.items;
  }
  else if(ecommerce.hasOwnProperty('purchase') && ecommerce.purchase.hasOwnProperty('items')){
    return ecommerce.purchase.items;
  } 
}
else if(returnMode == 'event_name'){
  if(ecommerce.hasOwnProperty('items') || (ecommerce.hasOwnProperty('purchase') && ecommerce.purchase.hasOwnProperty('items'))){
    return copyFromDataLayer('event', 2);
  }
}

if (ecommerce.impressions) {
  eventName = 'view_item_list';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.impressions.length; i++) {
      let product = ecommerce.impressions[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': product.hasOwnProperty('list') ? product.list : undefined,
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }
  }
}
if (ecommerce.click) {
  eventName = 'select_item';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.click.products.length; i++) {
      let product = ecommerce.click.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': product.hasOwnProperty('list') ? product.list : undefined,
        'item_list_id': ecommerce.click.hasOwnProperty('actionField') && ecommerce.click.actionField.hasOwnProperty('list') ? ecommerce.click.actionField.list : '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }
  }
}
if (ecommerce.detail) {
  eventName = 'view_item';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.detail.products.length; i++) {
      let product = ecommerce.detail.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': product.hasOwnProperty('list') ? product.list : undefined,
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': 1,
        'currency': currencyValue
      }; 
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }
  }
}
if (ecommerce.add) {
  eventName = 'add_to_cart';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.add.products.length; i++) {
      let product = ecommerce.add.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': product.hasOwnProperty('list') ? product.list : undefined,
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': product.hasOwnProperty('quantity') ? makeInteger(product.quantity) : 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }  
  }
}
if (ecommerce.remove) {
  eventName = 'remove_from_cart';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.remove.products.length; i++) {
      let product = ecommerce.remove.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': product.hasOwnProperty('list') ? product.list : undefined,
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': product.hasOwnProperty('quantity') ? makeInteger(product.quantity) : 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }  
  }
} 
if (ecommerce.checkout) { 
  if(returnMode == 'event_name'){
    let currentStep = ecommerce.checkout.actionField.step;
    if(data.tickViewCart && view_cart_step == currentStep){
  	  eventName = 'view_cart';
    }
    else if((begin_checkout_step === '' && currentStep == 1) || begin_checkout_step == currentStep){
	  eventName = 'begin_checkout';
    }
    else if((add_shipping_info_step === '' && currentStep == 2) || add_shipping_info_step == currentStep){
      eventName = 'add_shipping_info';
    }
    else if((add_payment_info_step === '' && currentStep == 3) || add_payment_info_step == currentStep){
      eventName = 'add_payment_info';
    }
  }
  else{
    eventName = '';
  }
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.checkout.products.length; i++) {
      let product = ecommerce.checkout.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': '',
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': product.hasOwnProperty('quantity') ? makeInteger(product.quantity) : 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }
  }
}
if (ecommerce.purchase) {
  eventName = 'purchase';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.purchase.products.length; i++) {
      let product = ecommerce.purchase.products[i];
      let item = {
        'item_name': product.hasOwnProperty('name') ? product.name : undefined,
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'price': round(product.hasOwnProperty('price') ? product.price : 0),
        'item_brand': product.hasOwnProperty('brand') ? product.brand : undefined,
        'item_category': product.hasOwnProperty('category') ? product.category.split('/')[0] : undefined,
        'item_category2': product.hasOwnProperty('category') ? product.category.split('/')[1] : undefined,
        'item_category3': product.hasOwnProperty('category') ? product.category.split('/')[2] : undefined,
        'item_category4': product.hasOwnProperty('category') ? product.category.split('/')[3] : undefined,
        'item_variant': product.hasOwnProperty('variant') ? product.variant : undefined,
        'item_list_name': '',
        'item_list_id': '',
        'index': product.hasOwnProperty('position') ? product.position : undefined,
        'quantity': product.hasOwnProperty('quantity') ? makeInteger(product.quantity) : 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }  
  }
}
if (ecommerce.refund) {
  eventName = 'refund';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.refund.products.length; i++) {
      let product = ecommerce.refund.products[i];
      let item = {
        'item_id': product.hasOwnProperty('id') ? product.id : undefined,
        'quantity': product.hasOwnProperty('quantity') ? makeInteger(product.quantity) : 1,
        'currency': currencyValue
      };
      item = parseDimensionsMetrics(product, item);
      items.push(item);
    }  
  }
}
if (ecommerce.promoView) {
  eventName = 'view_promotion';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.promoView.promotions.length; i++) {
      let promo = ecommerce.promoView.promotions[i];
      let item = {
        'promotion_name': promo.hasOwnProperty('name') ? promo.name : undefined,
        'promotion_id': promo.id,
        'creative_name': promo.hasOwnProperty('creative') ? promo.creative : undefined,
        'creative_slot': promo.hasOwnProperty('position') ? promo.position : undefined,
      };      
      item = parseDimensionsMetrics(promo, item);
      items.push(item);
    }  
  }
}
if (ecommerce.promoClick) {
  eventName = 'select_promotion';
  if(returnMode == 'items'){
    for (i = 0; i < ecommerce.promoClick.promotions.length; i++) {
      let promo = ecommerce.promoClick.promotions[i];
      let item = {
        'promotion_name': promo.hasOwnProperty('name') ? promo.name : undefined,
        'promotion_id': promo.id,
        'creative_name': promo.hasOwnProperty('creative') ? promo.creative : undefined,
        'creative_slot': promo.hasOwnProperty('position') ? promo.position : undefined,
      };
      item = parseDimensionsMetrics(promo, item);
      items.push(item);
    }  
  }
}

if(returnMode == 'items'){
  return items;
}
else if(returnMode == 'event_name'){
  if(eventName === undefined || eventName === ''){
    return '';
  }
  return eventName;
}
else{
  return undefined;
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ecommerceVariable"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ecommerce.*"
              },
              {
                "type": 1,
                "string": "event"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___



