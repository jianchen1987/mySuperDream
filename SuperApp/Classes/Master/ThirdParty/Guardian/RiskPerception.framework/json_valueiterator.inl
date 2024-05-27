// Copyright 2007-2010 Baptiste Lepilleur and The JsonCpp Authors
// Distributed under MIT license, or public domain if desired and
// recognized in your jurisdiction.
// See file LICENSE for detail or copy at http://jsoncpp.sourceforge.net/LICENSE

// included by json_value.cpp

namespace NTES_Risk_Json {

// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// class ValueIteratorBase
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////

ValueIteratorBase::ValueIteratorBase() : current_() {}

ValueIteratorBase::ValueIteratorBase(
    const NTES_Risk_Value::ObjectValues::iterator& current)
    : current_(current), isNull_(false) {}

NTES_Risk_Value& ValueIteratorBase::deref() { return current_->second; }
const NTES_Risk_Value& ValueIteratorBase::deref() const { return current_->second; }

void ValueIteratorBase::increment() { ++current_; }

void ValueIteratorBase::decrement() { --current_; }

ValueIteratorBase::difference_type
ValueIteratorBase::computeDistance(const SelfType& other) const {
  // Iterator for null value are initialized using the default
  // constructor, which initialize current_ to the default
  // std::map::iterator. As begin() and end() are two instance
  // of the default std::map::iterator, they can not be compared.
  // To allow this, we handle this comparison specifically.
  if (isNull_ && other.isNull_) {
    return 0;
  }

  // Usage of std::distance is not portable (does not compile with Sun Studio 12
  // RogueWave STL,
  // which is the one used by default).
  // Using a portable hand-made version for non random iterator instead:
  //   return difference_type( std::distance( current_, other.current_ ) );
  difference_type myDistance = 0;
  for (NTES_Risk_Value::ObjectValues::iterator it = current_; it != other.current_;
       ++it) {
    ++myDistance;
  }
  return myDistance;
}

bool ValueIteratorBase::isEqual(const SelfType& other) const {
  if (isNull_) {
    return other.isNull_;
  }
  return current_ == other.current_;
}

void ValueIteratorBase::copy(const SelfType& other) {
  current_ = other.current_;
  isNull_ = other.isNull_;
}

NTES_Risk_Value ValueIteratorBase::key() const {
  const NTES_Risk_Value::NTES_Risk_CZString czstring = (*current_).first;
  if (czstring.data()) {
    if (czstring.isStaticString())
      return NTES_Risk_Value(StaticString(czstring.data()));
    return NTES_Risk_Value(czstring.data(), czstring.data() + czstring.length());
  }
  return NTES_Risk_Value(czstring.index());
}

UInt ValueIteratorBase::index() const {
  const NTES_Risk_Value::NTES_Risk_CZString czstring = (*current_).first;
  if (!czstring.data())
    return czstring.index();
  return NTES_Risk_Value::UInt(-1);
}

NTES_Risk_String ValueIteratorBase::name() const {
  char const* keey;
  char const* end;
  keey = memberName(&end);
  if (!keey)
    return NTES_Risk_String();
  return NTES_Risk_String(keey, end);
}

char const* ValueIteratorBase::memberName() const {
  const char* cname = (*current_).first.data();
  return cname ? cname : "";
}

char const* ValueIteratorBase::memberName(char const** end) const {
  const char* cname = (*current_).first.data();
  if (!cname) {
    *end = nullptr;
    return nullptr;
  }
  *end = cname + (*current_).first.length();
  return cname;
}

// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// class ValueConstIterator
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////

ValueConstIterator::ValueConstIterator() = default;

ValueConstIterator::ValueConstIterator(
    const NTES_Risk_Value::ObjectValues::iterator& current)
    : ValueIteratorBase(current) {}

ValueConstIterator::ValueConstIterator(ValueIterator const& other)
    : ValueIteratorBase(other) {}

ValueConstIterator& ValueConstIterator::
operator=(const ValueIteratorBase& other) {
  copy(other);
  return *this;
}

// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// class ValueIterator
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////

ValueIterator::ValueIterator() = default;

ValueIterator::ValueIterator(const NTES_Risk_Value::ObjectValues::iterator& current)
    : ValueIteratorBase(current) {}

ValueIterator::ValueIterator(const ValueConstIterator& other)
    : ValueIteratorBase(other) {
  throwRuntimeError("ConstIterator to Iterator should never be allowed.");
}

ValueIterator::ValueIterator(const ValueIterator& other) = default;

ValueIterator& ValueIterator::operator=(const SelfType& other) {
  copy(other);
  return *this;
}

} // namespace Json
