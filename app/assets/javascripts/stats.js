var Hecosire = Hecosire || {};
Hecosire.generateStatCharts = function(pieId, pieColumns, linesId, linesColumns, comments) {
  var healthStates = ['Sick', 'Coming down', 'Recovering', 'Healthy'];
  var chart = c3.generate({
    bindto: pieId,
    data: {
      columns: pieColumns,
      type: 'pie'
    },
  });

  chart.resize();

  var chart2 = c3.generate({
    bindto: linesId,
    data: {
      x: 'x',
      xFormat: '%Y-%m-%d %I:%M', // 'xFormat' can be used as custom format of 'x'
      columns: linesColumns
    },
    tooltip: {
        format: {
            title: function (d) { return d.toLocaleDateString() + " "+d.toLocaleTimeString(); },
            value: function (value, ratio, id, index) { return healthStates[value-1] + ": " +comments[index]; }
            }
    },
    grid: {
      y: {
        lines: [
          {value: 3.99, text: 'Healthy'} ,
          {value: 2.99, text: 'Recovering'},
          {value: 1.99, text: 'Coming down'},
          {value: 0.99, text: 'Sick'}
        ]
      }
    },
    axis: {
      x: {
        type: 'timeseries',
        localtime: false,
        tick: {
          format: '%Y-%m-%d %I:%M',
          rotate: 40,
          culling: {
            max: 4 // the number of tick texts will be adjusted to less than this value
          }
        },

      },
      y: {
        label: 'State',
        show: false, 
        tick: {
          values: [1, 2, 3, 4]
        }
      }
    }
  });

  chart2.resize();
};
