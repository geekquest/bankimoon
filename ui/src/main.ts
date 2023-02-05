import { createApp } from 'vue'
import { createPinia } from 'pinia'
import {
    Button,
    Cell,
    CellGroup,
    Checkbox,
    Col,
    Collapse,
    CollapseItem,
    Divider,
    Empty,
    Field,
    List,
    NavBar,
    Notify,
    Picker,
    Popup,
    Radio,
    RadioGroup,
    Row,
    Search,
    Space,
    Switch,
    Toast,
    Tab,
    Tabs,
    SwipeCell,
} from 'vant'

import App from './App.vue'
import 'vant/lib/index.css';
import './assets/main.css'

const app = createApp(App)

app.use(createPinia())
app.use(Button)
app.use(Cell)
app.use(CellGroup)
app.use(Checkbox)
app.use(Col)
app.use(Collapse)
app.use(CollapseItem)
app.use(Divider)
app.use(Empty)
app.use(Field)
app.use(List)
app.use(NavBar)
app.use(Notify)
app.use(Picker)
app.use(Popup)
app.use(Radio)
app.use(RadioGroup)
app.use(Row)
app.use(Search)
app.use(Space)
app.use(SwipeCell)
app.use(Switch)
app.use(Tab)
app.use(Tabs)
app.use(Toast)

app.mount('#app')
