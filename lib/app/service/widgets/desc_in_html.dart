import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:qixer/shared/const_helper.dart';

class DescInHtml extends StatelessWidget {
  const DescInHtml({Key? key, this.desc}) : super(key: key);
  final desc;

  @override
  Widget build(BuildContext context) {
    return //product desc
        HtmlWidget(
      // the first parameter (`html`) is required
      '''

     $desc

     
  ''',

      // all other parameters are optional, a few notable params:

      // specify custom styling for an element
      // see supported inline styling below
      // customStylesBuilder: (element) {
      //   if (element.outerHtml.contains('p')) {
      //     return {'color': 'red'};
      //   }

      //   return null;
      // },

      // turn on selectable if required (it's disabled by default)
      isSelectable: true,

      // these callbacks are called when a complicated element is loading
      // or failed to render allowing the app to render progress indicator
      // and fallback widget
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          CircularProgressIndicator(),

      // this callback will be triggered when user taps a link

      // select the render mode for HTML body
      // by default, a simple `Column` is rendered
      // consider using `ListView` or `SliverList` for better performance
      renderMode: RenderMode.column,

      // set the default styling for text
      textStyle: mainFont.copyWith(fontSize: 15),

      // turn on `webView` if you need IFRAME support (it's disabled by default)
      webView: true,
    );
  }
}
