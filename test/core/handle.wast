(module
    (func (param $x handle)
        (segment.free (segment.new (i32.const 1))))

    (func (param $x handle) (result handle)
        (handle.slice
            (local.get $x)
            (i32.const 0)
            (i32.const 4)))

    (func (param $x handle) (result handle)
        (handle.add
            (local.get $x)
            (i32.const 0)))

    (func (param $x handle) (result handle)
        (handle.sub
            (local.get $x)
            (i32.const 0))))