pub type Vector =
  #(Int, Int)

pub fn add(v1: Vector, v2: Vector) -> Vector {
  #(v1.0 + v2.0, v1.1 + v2.1)
}

pub fn negate(v: Vector) -> Vector {
  #(-v.0, -v.1)
}

pub fn sub(v1: Vector, v2: Vector) -> Vector {
  add(v1, negate(v2))
}

pub fn scalar_multiply(v: Vector, factor: Int) -> Vector {
  #(v.0 * factor, v.1 * factor)
}
