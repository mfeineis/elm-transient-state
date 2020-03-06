(function () {
    "use strict";

    class UiState extends HTMLElement {
        constructor(...events) {
            super();
            this._events = events;
            this._handlers = {};
        }
        connectedCallback() {
            this._state = {};
            for (let { name, value } of this.attributes) {
                this._state[name] = this._parseAttribute(name, value);
                this._applyState(name);
            }
            for (let evt of this._events) {
                const handler = this._handleEvent.bind(this, evt);
                this.addEventListener(evt, handler);
                this._handlers[evt] = handler;
            }
        }
        disconnectedCallback() {
            for (let evt of this._events) {
                this.removeEventListener(evt, this._handlers[evt]);
            }
        }
        attributeChanged(name, oldValue, newValue) {
            //console.log('ui-toggle.state:set', name, oldValue, newValue);
            this._state[name] = this._parseAttribute(name, newValue);
        }
        _emit(name, detail) {
            this.dispatchEvent(new CustomEvent(name, { detail }));
        }
        _parseAttribute(name, value) {
            return value;
        }
        _handleEvent(name, ev) { }
        _applyState(prop) { }
    }

    customElements.define('ui-toggle', class extends UiState {
        constructor() {
            super('click');
        }
        _parseAttribute(name, value) {
            switch (name) {
                case 'open':
                    return value === 'true';
                default:
                    return value;
            }
        }
        _handleEvent(name, ev) {
            if (name === 'click' && ev.target.hasAttribute('ui-toggle')) {
                const what = ev.target.getAttribute('ui-toggle');
                this._state[what] = !this._state[what];
                //console.log(`  has "ui-toggle=${what}"; toggling state to`, state);
                this._applyState(what);
                this._emit('change', { [what]: this._state[what] });
            }
        }
        _applyState(prop) {
            this.setAttribute(prop, this._state[prop]);
            this.querySelector(`[ui-toggle-content="${prop}"]`).style.display = this._state[prop] ? 'block' : 'none';
        }
    });

}());