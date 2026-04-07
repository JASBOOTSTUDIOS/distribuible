const e = React.createElement;

function useJson(url, initialValue) {
  const state = React.useState(initialValue);
  const value = state[0];
  const setValue = state[1];
  const loadingState = React.useState(true);
  const loading = loadingState[0];
  const setLoading = loadingState[1];

  React.useEffect(function () {
    fetch(url)
      .then(function (r) { return r.json(); })
      .then(function (d) { setValue(d); setLoading(false); })
      .catch(function () { setLoading(false); });
  }, [url]);

  return { value, loading };
}

function App() {
  const salud = useJson('/api/salud', { estado: 'cargando' });
  const rutas = useJson('/api/rutas', { rutas: [] });
  const mensajeState = React.useState('Pulsa el boton para pedir datos a Forja.');
  const mensaje = mensajeState[0];
  const setMensaje = mensajeState[1];

  function cargarMensaje() {
    fetch('/api/mensaje')
      .then(function (r) { return r.json(); })
      .then(function (d) { setMensaje(d.mensaje || 'sin mensaje'); })
      .catch(function () { setMensaje('error al cargar'); });
  }

  return e('div', { className: 'fr-app' }, [
    e('section', { className: 'fr-card fr-hero', key: 'hero' }, [
      e('span', { className: 'forja-react-badge', key: 'badge' }, 'Plantilla productiva'),
      e('h1', { key: 'h1' }, 'Forja + React Full-Stack'),
      e('p', { key: 'p' }, 'Esta base separa assets, expone API real y deja lista una estructura escalable para monolitos Jasboot con interfaz React.'),
      e('div', { className: 'fr-topnav', key: 'nav' }, [
        e('a', { className: 'fr-link', href: '/' , key: 'n1'}, 'Inicio'),
        e('a', { className: 'fr-link', href: '/api/salud', key: 'n2' }, 'API Salud'),
        e('a', { className: 'fr-link', href: '/api/rutas', key: 'n3' }, 'API Rutas'),
        e('a', { className: 'fr-link', href: '/assets/app.js', key: 'n4' }, 'JS'),
        e('a', { className: 'fr-link', href: '/assets/app.css', key: 'n5' }, 'CSS')
      ]),
      e('div', { className: 'fr-kpis', key: 'kpis' }, [
        e('div', { className: 'fr-kpi', key: 'k1' }, [e('strong', { key: 'v1' }, '1'), e('span', { key: 'l1' }, 'monolito')]),
        e('div', { className: 'fr-kpi', key: 'k2' }, [e('strong', { key: 'v2' }, 'React'), e('span', { key: 'l2' }, 'UI cliente')]),
        e('div', { className: 'fr-kpi', key: 'k3' }, [e('strong', { className: 'fr-status', key: 'v3' }, salud.loading ? '...' : (salud.value.estado || 'ok')), e('span', { key: 'l3' }, 'estado API')])
      ])
    ]),
    e('section', { className: 'fr-grid', key: 'grid' }, [
      e('article', { className: 'fr-card', key: 'a1' }, [
        e('h3', { key: 't1' }, 'Demo viva'),
        e('p', { className: 'fr-muted', key: 'p1' }, 'La UI corre en React y consume endpoints nativos de Forja.'),
        e('div', { style: { height: '12px' }, key: 's1' }),
        e('button', { className: 'fr-button', onClick: cargarMensaje, key: 'btn' }, 'Consultar API'),
        e('div', { style: { height: '12px' }, key: 's2' }),
        e('p', { key: 'msg' }, mensaje)
      ]),
      e('article', { className: 'fr-card', key: 'a2' }, [
        e('h3', { key: 't2' }, 'Superficie API'),
        e('div', { className: 'fr-list', key: 'list' }, (rutas.value.rutas || []).map(function (ruta, i) {
          return e('div', { className: 'fr-item', key: 'i' + i }, ruta);
        }))
      ])
    ]),
    e('section', { className: 'fr-card', key: 'code' }, [
      e('h3', { key: 't3' }, 'Estructura sugerida'),
      e('div', { className: 'fr-code', key: 'c' }, "examples/forja_react_app/\n  app.jasb\n  assets/\n    app.css\n    app.js\n\nForja sirve HTML + assets + API desde la misma app.")
    ])
  ]);
}

ReactDOM.render(e(App), document.getElementById('root'));
