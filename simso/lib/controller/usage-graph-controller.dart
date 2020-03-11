import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/timer-model.dart';
import 'package:simso/model/entities/touch-counter-model.dart';
import 'package:simso/view/usage-graph-page.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart' as textElement;


class UsageGraphController {
  UsageGraphPageState state;
  Wrapper timeWrapper = new Wrapper(0);
  Wrapper touchWrapper = new Wrapper(0);

  UsageGraphController(this.state);

  List<Series<TimerModel, String>> get getTimerSeries {
    return [
      new Series(
        id: 'Time', 
        data: state.timers, 
        domainFn: (TimerModel timer, _) => getDayOfWeek(timer.day), 
        measureFn: (TimerModel timer, _) => (timer.timeOnAppSec / 60).truncate())
    ];
  }

  get getTimerChart {
    var chart = BarChart(
      getTimerSeries,
      animate: true,
      selectionModels: [
        SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection)
              timeWrapper.number = model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
          }
        )
      ],
      behaviors: [
        LinePointHighlighter(
          showVerticalFollowLine: LinePointHighlighterFollowLineType.none,
          defaultRadiusPx: 0,
          symbolRenderer: CustomCircleSymbolRenderer(timeWrapper)
        )
      ],
      domainAxis: OrdinalAxisSpec(
        renderSpec: SmallTickRendererSpec(
            // Tick and Label styling here.
            labelStyle: TextStyleSpec(
                fontSize: 16, // size in Pts.
                color: MaterialPalette.white),
            // Change the line colors to match text color.
            lineStyle: LineStyleSpec(
                color: MaterialPalette.white))),
      primaryMeasureAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: TextStyleSpec(
                fontSize: 16, // size in Pts.
                color: MaterialPalette.white),
            // Change the line colors to match text color.
            lineStyle: LineStyleSpec(
                color: MaterialPalette.transparent))),

    );

    return new Padding(
      padding: new EdgeInsets.all(20),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
  }

  List<Series<TouchCounterModel, String>> get getTouchSeries {
    return [
      new Series(
        id: 'Touches', 
        data: state.touchCounters, 
        domainFn: (TouchCounterModel touchCounter, _) => getDayOfWeek(touchCounter.day), 
        measureFn: (TouchCounterModel touchCounter, _) => touchCounter.touches)
    ];
  }

  get getTouchChart {
    var chart = BarChart(
      getTouchSeries,
      animate: true,
      selectionModels: [
        SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if (model.hasDatumSelection)
              touchWrapper.number = model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
          }
        )
      ],
      behaviors: [
        LinePointHighlighter(
          showVerticalFollowLine: LinePointHighlighterFollowLineType.none,
          defaultRadiusPx: 0,
          symbolRenderer: CustomCircleSymbolRenderer(touchWrapper)
        )
      ],
      domainAxis: OrdinalAxisSpec(
        renderSpec: SmallTickRendererSpec(
            // Tick and Label styling here.
            labelStyle: TextStyleSpec(
                fontSize: 16, // size in Pts.
                color: MaterialPalette.white),
            // Change the line colors to match text color.
            lineStyle: LineStyleSpec(
                color: MaterialPalette.white))),
      primaryMeasureAxis: NumericAxisSpec(
        renderSpec: GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: TextStyleSpec(
                fontSize: 16, // size in Pts.
                color: MaterialPalette.white),
            // Change the line colors to match text color.
            lineStyle: LineStyleSpec(
                thickness: 0,
                color: MaterialPalette.transparent))),
    );

    return new Padding(
      padding: new EdgeInsets.all(20),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
  }

  

  String getDayOfWeek(String dateString) {
    var firstDashIndex = dateString.indexOf('/', 1);
    var secondDashIndex = dateString.indexOf('/', 2);

    var month = int.parse(dateString.substring(0, firstDashIndex));
    var day = int.parse(dateString.substring(firstDashIndex + 1, secondDashIndex));
    var year = int.parse(dateString.substring(secondDashIndex + 1));

    var date = new DateTime(year, month, day);
    var dayOfWeek = DateFormat('EEEE').format(date);
    var currentDate = DateFormat('EEEE').format(DateTime.now());
    if (dayOfWeek == currentDate)
      return 'Today';
    return dayOfWeek.substring(0, 3);
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  Wrapper wrapper;

  CustomCircleSymbolRenderer(this.wrapper);
  @override
  void paint(
    ChartCanvas canvas, 
    Rectangle<num> bounds, 
    {List<int> dashPattern, 
    Color fillColor, 
    Color strokeColor, 
    double strokeWidthPx, 
    FillPatternType fillPattern}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
      textElement.TextElement(wrapper.number.toString(), style: textStyle),
      (bounds.left - 5).round(),
      (bounds.top -20).round()
    );
  }
}

class Wrapper {
  Wrapper(this.number);
  int number;
}