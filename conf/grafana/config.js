define(['settings'],
function (Settings) {
  return new Settings({
    //elasticsearch: "http://"+window.location.hostname+":9200",
    datasources: {
      graphite: {
        default: true,
        type: 'graphite',
        url: "<--GRAPHITE_PROTO-->://<--GRAPHITE_USER-->:<--GRAPHITE_PASS-->@<--GRAPHITE_ADDR-->:<--GRAPHITE_PORT-->",
      },
      elasticsearch: {
        type: 'elasticsearch',
        url: "<--ELASTICSEARCH_PROTO-->://<--ELASTICSEARCH_USER-->:<--ELASTICSEARCH_PASS-->@<--ELASTICSEARCH_ADDR-->:<--ELASTICSEARCH_PORT-->",
        index: 'grafana-dash',
        grafanaDB: true,
      }
    },
    default_route: '/dashboard/file/default.json',
    timezoneOffset: null,
    grafana_index: "grafana-dash",
    unsaved_changes_warning: true,
    panel_names: ['text','graphite']
  });
});
