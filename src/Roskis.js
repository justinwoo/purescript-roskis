exports.getMysteryBox_ = function () {
  return {};
};

exports.unsafeSetMysteryBox = function (key) {
  return function (value) {
    return function (record) {
      return function () {
        record[key] = value;
        return void 0;
      };
    };
  };
};

exports.boxToRecord_ = function(box) {
  return function () {
    return box;
  };
};
