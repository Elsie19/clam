#!/bin/bash

function assert.is_root() {
    return $(("${EUID}" == 0 ? 0 : 1))
}
