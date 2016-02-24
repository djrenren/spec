(module
  ;; Statement switch
  (func $stmt (param $i i32) (result i32)
    (local $j i32)
    (set_local $j (i32.const 100))
    (block $switch
      (block $7
        (block $default
          (block $6
            (block $5
              (block $4
                (block $3
                  (block $2
                    (block $1
                      (block $0
                        (br_table $0 $1 $2 $3 $4 $5 $6 $7 (get_local $i))
                        (br $default)
                      ) ;; 0
                      (return (get_local $i))
                    ) ;; 1
                    (nop)
                    ;; fallthrough
                  ) ;; 2
                  ;; fallthrough
                ) ;; 3
                (set_local $j (i32.sub (i32.const 0) (get_local $i)))
                (br $switch)
              ) ;; 4
              (br $switch)
            ) ;; 5
            (set_local $j (i32.const 101))
            (br $switch)
          ) ;; 6
          (set_local $j (i32.const 101))
          ;; fallthrough
        ) ;; default
        (set_local $j (i32.const 102))
      ) ;; 7
      ;; fallthrough
    )
    (return (get_local $j))
  )

  ;; Expression switch
  (func $expr (param $i i64) (result i64)
    (local $j i64)
    (set_local $j (i64.const 100))
    (return
      (block $switch
        (block $7
          (block $default
            (block $4
              (block $5
                (block $6
                  (block $3
                    (block $2
                      (block $1
                        (block $0
                          (br_table $0 $1 $2 $3 $4 $5 $6 $7
                            (i32.wrap/i64 (get_local $i))
                          )
                          (br $default)
                        ) ;; 0
                        (return (get_local $i))
                      ) ;; 1
                      (nop)
                      ;; fallthrough
                    ) ;; 2
                    ;; fallthrough
                  ) ;; 3
                  (br $switch (i64.sub (i64.const 0) (get_local $i)))
                ) ;; 6
                (set_local $j (i64.const 101))
                ;; fallthrough
              ) ;; 4
              ;; fallthrough
            ) ;; 5
            ;; fallthrough
          ) ;; default
          (br $switch (get_local $j))
        ) ;; 7
        (i64.const -5)
      )
    )
  )

  ;; Argument switch
  (func $arg (param $i i32) (result i32)
    (return
      (block $2
        (i32.add (i32.const 10)
          (block $1
            (i32.add (i32.const 100)
              (block $0
                (br_table $0 $1 $2
                  (i32.mul (i32.const 2) (get_local $i))
                  (i32.and (i32.const 3) (get_local $i))
                )
                (i32.add (i32.const 1000) (get_local $i))
              )
            )
          )
        )
      )
    )
  )

  ;; Corner cases
  (func $corner (result i32)
    (br_table (i32.const 0))
    (i32.const 1)
  )

  (export "stmt" $stmt)
  (export "expr" $expr)
  (export "arg" $arg)
  (export "corner" $corner)
)

(assert_return (invoke "stmt" (i32.const 0)) (i32.const 0))
(assert_return (invoke "stmt" (i32.const 1)) (i32.const -1))
(assert_return (invoke "stmt" (i32.const 2)) (i32.const -2))
(assert_return (invoke "stmt" (i32.const 3)) (i32.const -3))
(assert_return (invoke "stmt" (i32.const 4)) (i32.const 100))
(assert_return (invoke "stmt" (i32.const 5)) (i32.const 101))
(assert_return (invoke "stmt" (i32.const 6)) (i32.const 102))
(assert_return (invoke "stmt" (i32.const 7)) (i32.const 100))
(assert_return (invoke "stmt" (i32.const -10)) (i32.const 102))

(assert_return (invoke "expr" (i64.const 0)) (i64.const 0))
(assert_return (invoke "expr" (i64.const 1)) (i64.const -1))
(assert_return (invoke "expr" (i64.const 2)) (i64.const -2))
(assert_return (invoke "expr" (i64.const 3)) (i64.const -3))
(assert_return (invoke "expr" (i64.const 6)) (i64.const 101))
(assert_return (invoke "expr" (i64.const 7)) (i64.const -5))
(assert_return (invoke "expr" (i64.const -10)) (i64.const 100))

(assert_return (invoke "arg" (i32.const 0)) (i32.const 110))
(assert_return (invoke "arg" (i32.const 1)) (i32.const 12))
(assert_return (invoke "arg" (i32.const 2)) (i32.const 4))
(assert_return (invoke "arg" (i32.const 3)) (i32.const 1113))
(assert_return (invoke "arg" (i32.const 4)) (i32.const 118))
(assert_return (invoke "arg" (i32.const 5)) (i32.const 20))
(assert_return (invoke "arg" (i32.const 6)) (i32.const 12))
(assert_return (invoke "arg" (i32.const 7)) (i32.const 1117))
(assert_return (invoke "arg" (i32.const 8)) (i32.const 126))

(assert_return (invoke "corner") (i32.const 1))

(assert_invalid (module (func (br_table 3 (i32.const 0)))) "unknown label")
