unit TestEmailAddressValidator;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, EmailValidator;

type
  // Test methods for class TEmailValidator

  TestTEmailValidator = class(TTestCase)
  strict private
    FEmailValidator: TEmailValidator;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    // To enable this test make it 'published'
    procedure testEmailFromPerl;
  published
    procedure testEmail;
    procedure testEmailWithNumericAddress;
    procedure testEmailExtension;
    procedure testEmailWithDash;
    procedure testEmailWithDotEnd;
    procedure testEmailWithBogusCharacter;
    procedure testEmailWithCommas;
    procedure testEmailWithSpaces;
    procedure testEmailWithControlChars;
    procedure testEmailUserName;
    procedure testValidator293;
  end;

implementation

uses SysUtils;

procedure TestTEmailValidator.SetUp;
begin
  FEmailValidator := TEmailValidator.Create;
end;

procedure TestTEmailValidator.TearDown;
begin
  FreeAndNil(FEmailValidator);
end;

// Tests the e-mail validation.
procedure TestTEmailValidator.testEmail;
begin
  CheckTrue(FEmailValidator.isValid('jsmith@apache.org'), 'jsmith@apache.org');
end;

// Tests the email validation with numeric domains.
procedure TestTEmailValidator.testEmailWithNumericAddress;
begin
  CheckTrue(FEmailValidator.isValid('someone@[216.109.118.76]'),
    'someone@[216.109.118.76]');
  CheckTrue(FEmailValidator.isValid('someone@yahoo.com'), 'someone@yahoo.com');
end;

// Tests the e-mail validation.
procedure TestTEmailValidator.testEmailExtension;
begin
  CheckTrue(FEmailValidator.isValid('jsmith@apache.org'), 'jsmith@apache.org');
  CheckTrue(FEmailValidator.isValid('jsmith@apache.com'), 'jsmith@apache.com');
  CheckTrue(FEmailValidator.isValid('jsmith@apache.net'), 'jsmith@apache.net');
  CheckTrue(FEmailValidator.isValid('jsmith@apache.info'),
    'jsmith@apache.info');
  CheckFalse(FEmailValidator.isValid('jsmith@apache.'), 'jsmith@apache.');
  CheckFalse(FEmailValidator.isValid('jsmith@apache.c'), 'jsmith@apache.c');
  CheckTrue(FEmailValidator.isValid('someone@yahoo.museum'),
    'someone@yahoo.museum');
  CheckFalse(FEmailValidator.isValid('someone@yahoo.mu-seum'),
    'someone@yahoo.mu-seum');
end;
//
// <p>Tests the e-mail validation with a dash in
// the address.</p>

procedure TestTEmailValidator.testEmailWithDash;
begin
  CheckTrue(FEmailValidator.isValid('andy.noble@data-workshop.com'),
    'andy.noble@data-workshop.com');
  CheckFalse(FEmailValidator.isValid('andy-noble@data-workshop.-com'),
    'andy-noble@data-workshop.-com');
  CheckFalse(FEmailValidator.isValid('andy-noble@data-workshop.c-om'),
    'andy-noble@data-workshop.c-om');
  CheckFalse(FEmailValidator.isValid('andy-noble@data-workshop.co-m'),
    'andy-noble@data-workshop.co-m');
end;
//
// Tests the e-mail validation with a dot at the end of
// the address.

procedure TestTEmailValidator.testEmailWithDotEnd;
begin
  CheckFalse(FEmailValidator.isValid('andy.noble@data-workshop.com.'),
    'andy.noble@data-workshop.com.');
end;
//
// Tests the e-mail validation with an RCS-noncompliant character in
// the address.

procedure TestTEmailValidator.testEmailWithBogusCharacter;
begin
  (*
    CheckFalse(FEmailValidator.isValid('andy.noble@\u008fdata-workshop.com'),
    'andy.noble@\u008fdata-workshop.com');
    // The ' character is valid in an email username.
    CheckTrue(FEmailValidator.isValid('andy.o' reilly@data -
    workshop.com '), ' andy.o 'reilly@data-workshop.com');
    // But not in the domain name.
    CheckFalse(FEmailValidator.isValid('andy@o' reilly.data -
    workshop.com '), ' andy@o 'reilly.data-workshop.com');
    // The + character is valid in an email username.
    CheckTrue(FEmailValidator.isValid('foo+bar@i.am.not.in.us.example.com'),
    'foo+bar@i.am.not.in.us.example.com');
    // But not in the domain name
    CheckFalse(FEmailValidator.isValid('foo+bar@example+3.com'),
    'foo+bar@example+3.com');
    // Domains with only special characters aren't allowed (VALIDATOR-286)
    CheckFalse(FEmailValidator.isValid('test@%*.com'), 'test@%*.com');
    CheckFalse(FEmailValidator.isValid('test@^&#.com'), 'test@^&#.com');
  *)
end;

// Tests the email validation with commas.
procedure TestTEmailValidator.testEmailWithCommas;
begin
  CheckFalse(FEmailValidator.isValid('joeblow@apa,che.org'),
    'joeblow@apa,che.org');
  CheckFalse(FEmailValidator.isValid('joeblow@apache.o,rg'),
    'joeblow@apache.o,rg');
  CheckFalse(FEmailValidator.isValid('joeblow@apache,org'),
    'joeblow@apache,org');
end;
//
// Tests the email validation with spaces.

procedure TestTEmailValidator.testEmailWithSpaces;
begin
  CheckFalse(FEmailValidator.isValid('joeblow @apache.org'),
    'joeblow @apache.org'); // TODO - this should be valid?
  CheckFalse(FEmailValidator.isValid('joeblow@ apache.org'),
    'joeblow@ apache.org');
  CheckTrue(FEmailValidator.isValid(' joeblow@apache.org'),
    ' joeblow@apache.org');
  // TODO - this should be valid?
  CheckTrue(FEmailValidator.isValid('joeblow@apache.org '),
    'joeblow@apache.org ');
  CheckFalse(FEmailValidator.isValid('joe blow@apache.org '),
    'joe blow@apache.org ');
  CheckFalse(FEmailValidator.isValid('joeblow@apa che.org '),
    'joeblow@apa che.org ');
end;
//
// Tests the email validation with ascii control characters.
// (i.e. Ascii chars 0 - 31 and 127)

procedure TestTEmailValidator.testEmailWithControlChars;
begin
  (*
    for (char c = 0; c < 32; c + +) {
    CheckFalse("Test control char " + ((int)c), FEmailValidator.isValid('foo" + c + "bar@domain.com'), 'foo" + c + "bar@domain.com');
    end;
    CheckFalse("Test control char 127", FEmailValidator.isValid('foo" + ((char)127) + "bar@domain.com'), 'foo" + ((char)127) + "bar@domain.com');
  *)
end;
//
// Test that @localhost and @localhost.localdomain
// addresses are declared as valid when requested.

procedure testEmailLocalhost;
begin
  (*
    // Check the default is not to allow
    EmailValidator noLocal = EmailValidator.getInstance(false);
    EmailValidator allowLocal = EmailValidator.getInstance(true);
    assertEquals(FEmailValidator, noLocal);

    // Depends on the FEmailValidator
    CheckTrue(
    "@localhost.localdomain should be accepted but wasn't",
    allowLocal.isValid('joe@localhost.localdomain'), 'joe@localhost.localdomain'
    );
    CheckTrue(
    "@localhost should be accepted but wasn't",
    allowLocal.isValid('joe@localhost'), 'joe@localhost'
    );

    CheckFalse(
    "@localhost.localdomain should be accepted but wasn't",
    noLocal.isValid('joe@localhost.localdomain'), 'joe@localhost.localdomain'
    );
    CheckFalse(
    "@localhost should be accepted but wasn't",
    noLocal.isValid('joe@localhost'), 'joe@localhost'
    );
  *)
end;

// VALIDATOR-296 - A / or a ! is valid in the user part,
// but not in the domain part
procedure testEmailWithSlashes;
begin
  (*
    CheckTrue(
    "/ and ! valid in username",
    FEmailValidator.isValid('joe!/blow@apache.org'), 'joe!/blow@apache.org'
    );
    CheckFalse(
    "/ not valid in domain",
    FEmailValidator.isValid('joe@ap/ache.org'), 'joe@ap/ache.org'
    );
    CheckFalse(
    "! not valid in domain",
    FEmailValidator.isValid('joe@apac!he.org'), 'joe@apac!he.org'
    );
  *)
end;
//
// Write this test according to parts of RFC, as opposed to the type of character
// that is being tested.

procedure TestTEmailValidator.testEmailUserName;
begin
  CheckTrue(FEmailValidator.isValid('joe1blow@apache.org'),
    'joe1blow@apache.org');
  CheckTrue(FEmailValidator.isValid('joe$blow@apache.org'),
    'joe$blow@apache.org');
  CheckTrue(FEmailValidator.isValid('joe-@apache.org'), 'joe-@apache.org');
  CheckTrue(FEmailValidator.isValid('joe_@apache.org'), 'joe_@apache.org');
  CheckTrue(FEmailValidator.isValid('joe+@apache.org'), 'joe+@apache.org');
  // + is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe!@apache.org'), 'joe!@apache.org');
  // ! is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe*@apache.org'), 'joe*@apache.org');
  // * is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe''@apache.org '), ' joe ''@apache.org');
  // ' is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe%45@apache.org'), 'joe%45@apache.org');
  // % is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe?@apache.org'), 'joe?@apache.org');
  // ? is valid unquoted
  CheckTrue(FEmailValidator.isValid('joe&@apache.org'), 'joe&@apache.org');
  // & ditto
  CheckTrue(FEmailValidator.isValid('joe=@apache.org'), 'joe=@apache.org');
  // = ditto
  CheckTrue(FEmailValidator.isValid('+joe@apache.org'), '+joe@apache.org');
  // + is valid unquoted
  CheckTrue(FEmailValidator.isValid('!joe@apache.org'), '!joe@apache.org');
  // ! is valid unquoted
  CheckTrue(FEmailValidator.isValid('*joe@apache.org'), '*joe@apache.org');
  // * is valid unquoted
  CheckTrue(FEmailValidator.isValid('''joe@apache.org '), '''joe@apache.org');
  // ' is valid unquoted
  CheckTrue(FEmailValidator.isValid('%joe45@apache.org'), '%joe45@apache.org');
  // % is valid unquoted
  CheckTrue(FEmailValidator.isValid('?joe@apache.org'), '?joe@apache.org');
  // ? is valid unquoted
  CheckTrue(FEmailValidator.isValid('&joe@apache.org'), '&joe@apache.org');
  // & ditto
  CheckTrue(FEmailValidator.isValid('=joe@apache.org'), '=joe@apache.org');
  // = ditto
  CheckTrue(FEmailValidator.isValid('+@apache.org'), '+@apache.org');
  // + is valid unquoted
  CheckTrue(FEmailValidator.isValid('!@apache.org'), '!@apache.org');
  // ! is valid unquoted
  CheckTrue(FEmailValidator.isValid('*@apache.org'), '*@apache.org');
  // * is valid unquoted
  CheckTrue(FEmailValidator.isValid('''@apache.org '), '''@apache.org');
  // ' is valid unquoted
  CheckTrue(FEmailValidator.isValid('%@apache.org'), '%@apache.org');
  // % is valid unquoted
  CheckTrue(FEmailValidator.isValid('?@apache.org'), '?@apache.org');
  // ? is valid unquoted
  CheckTrue(FEmailValidator.isValid('&@apache.org'), '&@apache.org');
  // & ditto
  CheckTrue(FEmailValidator.isValid('=@apache.org'), '=@apache.org');
  // = ditto
  // UnQuoted Special characters are invalid
  CheckFalse(FEmailValidator.isValid('joe.@apache.org'), 'joe.@apache.org');
  // . not allowed at end of local part
  CheckFalse(FEmailValidator.isValid('.joe@apache.org'), '.joe@apache.org');
  // . not allowed at start of local part
  CheckFalse(FEmailValidator.isValid('.@apache.org'), '.@apache.org');
  // . not allowed alone
  CheckTrue(FEmailValidator.isValid('joe.ok@apache.org'), 'joe.ok@apache.org');
  // . allowed embedded
  CheckFalse(FEmailValidator.isValid('joe..ok@apache.org'),
    'joe..ok@apache.org'); // .. not allowed embedded
  CheckFalse(FEmailValidator.isValid('..@apache.org'), '..@apache.org');
  // .. not allowed alone
  CheckFalse(FEmailValidator.isValid('joe(@apache.org'), 'joe(@apache.org');
  CheckFalse(FEmailValidator.isValid('joe)@apache.org'), 'joe)@apache.org');
  CheckFalse(FEmailValidator.isValid('joe,@apache.org'), 'joe,@apache.org');
  CheckFalse(FEmailValidator.isValid('joe;@apache.org'), 'joe;@apache.org');
  // Quoted Special characters are valid
  CheckTrue(FEmailValidator.isValid('"joe."@apache.org'), '"joe."@apache.org');
  CheckTrue(FEmailValidator.isValid('".joe"@apache.org'), '".joe"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe+"@apache.org'), '"joe+"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe!"@apache.org'), '"joe!"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe*"@apache.org'), '"joe*"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe'' "@apache.org '),
    ' " joe ''"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe("@apache.org'), '"joe("@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe)"@apache.org'), '"joe)"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe,"@apache.org'), '"joe,"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe%45"@apache.org'),
    '"joe%45"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe;"@apache.org'), '"joe;"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe?"@apache.org'), '"joe?"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe&"@apache.org'), '"joe&"@apache.org');
  CheckTrue(FEmailValidator.isValid('"joe="@apache.org'), '"joe="@apache.org');
  CheckTrue(FEmailValidator.isValid('".."@apache.org'), '".."@apache.org');
end;
//
// These test values derive directly from RFC 822 &
// Mail::RFC822::Address & RFC::RFC822::Address perl test.pl
// For traceability don't combine these test values with other tests.
// This test fails in the Apache suite!!!
procedure TestTEmailValidator.testEmailFromPerl;
begin
  CheckTrue(FEmailValidator.isValid('abigail@example.com'),
    'abigail@example.com');
  CheckTrue(FEmailValidator.isValid('abigail@example.com '),
    'abigail@example.com ');
  CheckTrue(FEmailValidator.isValid(' abigail@example.com'),
    ' abigail@example.com');
  CheckTrue(FEmailValidator.isValid('abigail @example.com '),
    'abigail @example.com ');
  CheckTrue(FEmailValidator.isValid('*@example.net'), '*@example.net');
  CheckTrue(FEmailValidator.isValid('"\""@foo.bar'), '"\""@foo.bar');
  CheckTrue(FEmailValidator.isValid('fred&barny@example.com'),
    'fred&barny@example.com');
  CheckTrue(FEmailValidator.isValid('---@example.com'), '---@example.com');
  CheckTrue(FEmailValidator.isValid('foo-bar@example.net'),
    'foo-bar@example.net');
  CheckTrue(FEmailValidator.isValid('"127.0.0.1"@[127.0.0.1]'),
    '"127.0.0.1"@[127.0.0.1]');
  CheckTrue(FEmailValidator.isValid('Abigail <abigail@example.com>'),
    'Abigail <abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('Abigail<abigail@example.com>'),
    'Abigail<abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('Abigail<@a,@b,@c:abigail@example.com>'),
    'Abigail<@a,@b,@c:abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('"This is a phrase"<abigail@example.com>'),
    '"This is a phrase"<abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('"Abigail "<abigail@example.com>'),
    '"Abigail "<abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('"Joe & J. Harvey" <example @Org>'),
    '"Joe & J. Harvey" <example @Org>');
  CheckTrue(FEmailValidator.isValid('Abigail <abigail @ example.com>'),
    'Abigail <abigail @ example.com>');
  CheckTrue(FEmailValidator.isValid
    ('Abigail made this <  abigail   @   example  .    com    >'),
    'Abigail made this <  abigail   @   example  .    com    >');
  CheckTrue(FEmailValidator.isValid('Abigail(the bitch)@example.com'),
    'Abigail(the bitch)@example.com');
  CheckTrue(FEmailValidator.isValid('Abigail <abigail @ example . (bar) com >'),
    'Abigail <abigail @ example . (bar) com >');
  CheckTrue(FEmailValidator.isValid
    ('Abigail < (one)  abigail (two) @(three)example . (bar) com (quz) >'),
    'Abigail < (one)  abigail (two) @(three)example . (bar) com (quz) >');
  CheckTrue(FEmailValidator.isValid
    ('Abigail (foo) (((baz)(nested) (comment)) ! ) < (one)  abigail (two) @(three)example . (bar) com (quz) >'),
    'Abigail (foo) (((baz)(nested) (comment)) ! ) < (one)  abigail (two) @(three)example . (bar) com (quz) >');
  CheckTrue(FEmailValidator.isValid('Abigail <abigail(fo\(o)@example.com>'),
    'Abigail <abigail(fo\(o)@example.com>');
  CheckTrue(FEmailValidator.isValid('Abigail <abigail(fo\)o)@example.com> '),
    'Abigail <abigail(fo\)o)@example.com> ');
  CheckTrue(FEmailValidator.isValid('(foo) abigail@example.com'),
    '(foo) abigail@example.com');
  CheckTrue(FEmailValidator.isValid('abigail@example.com (foo)'),
    'abigail@example.com (foo)');
  CheckTrue(FEmailValidator.isValid('"Abi\"gail" <abigail@example.com>'),
    '"Abi\"gail" <abigail@example.com>');
  CheckTrue(FEmailValidator.isValid('abigail@[example.com]'),
    'abigail@[example.com]');
  CheckTrue(FEmailValidator.isValid('abigail@[exa\[ple.com]'),
    'abigail@[exa\[ple.com]');
  CheckTrue(FEmailValidator.isValid('abigail@[exa\]ple.com]'),
    'abigail@[exa\]ple.com]');
  CheckTrue(FEmailValidator.isValid('":sysmail"@  Some-Group. Some-Org'),
    '":sysmail"@  Some-Group. Some-Org');
  CheckTrue(FEmailValidator.isValid
    ('Muhammed.(I am  the greatest) Ali @(the)Vegas.WBA'),
    'Muhammed.(I am  the greatest) Ali @(the)Vegas.WBA');
  CheckTrue(FEmailValidator.isValid('mailbox.sub1.sub2@this-domain'),
    'mailbox.sub1.sub2@this-domain');
  CheckTrue(FEmailValidator.isValid('sub-net.mailbox@sub-domain.domain'),
    'sub-net.mailbox@sub-domain.domain');
  CheckTrue(FEmailValidator.isValid('name:;'), 'name:;');
  CheckTrue(FEmailValidator.isValid(''':; '), ''':;');
  CheckTrue(FEmailValidator.isValid('name:   ;'), 'name:   ;');
  CheckTrue(FEmailValidator.isValid('Alfred Neuman <Neuman@BBN-TENEXA>'),
    'Alfred Neuman <Neuman@BBN-TENEXA>');
  CheckTrue(FEmailValidator.isValid('Neuman@BBN-TENEXA'), 'Neuman@BBN-TENEXA');
  CheckTrue(FEmailValidator.isValid('"George, Ted" <Shared@Group.Arpanet>'),
    '"George, Ted" <Shared@Group.Arpanet>');
  CheckTrue(FEmailValidator.isValid('Wilt . (the  Stilt) Chamberlain@NBA.US'),
    'Wilt . (the  Stilt) Chamberlain@NBA.US');
  CheckTrue(FEmailValidator.isValid('Cruisers:  Port@Portugal, Jones@SEA;'),
    'Cruisers:  Port@Portugal, Jones@SEA;');
  CheckTrue(FEmailValidator.isValid('$@[]'), '$@[]');
  CheckTrue(FEmailValidator.isValid('*()@[]'), '*()@[]');
  CheckTrue(FEmailValidator.isValid
    ('"quoted ( brackets" ( a comment )@example.com'),
    '"quoted ( brackets" ( a comment )@example.com');
  CheckTrue(FEmailValidator.isValid
    ('"Joe & J. Harvey"\x0D\x0A     <ddd\@ Org>'),
    '"Joe & J. Harvey"\x0D\x0A     <ddd\@ Org>');
  CheckTrue(FEmailValidator.isValid('"Joe &\x0D\x0A J. Harvey" <ddd \@ Org>'),
    '"Joe &\x0D\x0A J. Harvey" <ddd \@ Org>');
  // CheckTrue(FEmailValidator.isValid
  // ('Gourmets:  Pompous Person <WhoZiWhatZit\@Cordon-Bleu>,\x0D\x0A' +
  // '        Childs\@WGBH.Boston, "Galloping Gourmet"\@\x0D\x0A' +
  // '        ANT.Down-Under (Australian National Television),\x0D\x0A' +
  // '        Cheapie\@Discount-Liquors;');
  CheckFalse(FEmailValidator.isValid('   Just a string'), '   Just a string');
  CheckFalse(FEmailValidator.isValid('string'), 'string');
  CheckFalse(FEmailValidator.isValid('(comment)'), '(comment)');
  CheckFalse(FEmailValidator.isValid('()@example.com'), '()@example.com');
  CheckFalse(FEmailValidator.isValid('fred(&)barny@example.com'),
    'fred(&)barny@example.com');
  CheckFalse(FEmailValidator.isValid('fred\ barny@example.com'),
    'fred\ barny@example.com');
  CheckFalse(FEmailValidator.isValid('Abigail <abi gail @ example.com>'),
    'Abigail <abi gail @ example.com>');
  CheckFalse(FEmailValidator.isValid('Abigail <abigail(fo(o)@example.com>'),
    'Abigail <abigail(fo(o)@example.com>');
  CheckFalse(FEmailValidator.isValid('Abigail <abigail(fo)o)@example.com>'),
    'Abigail <abigail(fo)o)@example.com>');
  CheckFalse(FEmailValidator.isValid('"Abi"gail" <abigail@example.com>'),
    '"Abi"gail" <abigail@example.com>');
  CheckFalse(FEmailValidator.isValid('abigail@[exa]ple.com]'),
    'abigail@[exa]ple.com]');
  CheckFalse(FEmailValidator.isValid('abigail@[exa[ple.com]'),
    'abigail@[exa[ple.com]');
  CheckFalse(FEmailValidator.isValid('abigail@[exaple].com]'),
    'abigail@[exaple].com]');
  CheckFalse(FEmailValidator.isValid('abigail@'), 'abigail@');
  CheckFalse(FEmailValidator.isValid('@example.com'), '@example.com');
  CheckFalse(FEmailValidator.isValid
    ('phrase: abigail@example.com abigail@example.com ;'),
    'phrase: abigail@example.com abigail@example.com ;');
  CheckFalse(FEmailValidator.isValid(' invalid ? char@example.com'),
    ' invalid ? char@example.com');
end;

procedure TestTEmailValidator.testValidator293;
begin
  CheckTrue(FEmailValidator.isValid('abc-@abc.com'), 'abc-@abc.com');
  CheckTrue(FEmailValidator.isValid('abc_@abc.com'), 'abc_@abc.com');
  CheckTrue(FEmailValidator.isValid('abc-def@abc.com'), 'abc-def@abc.com');
  CheckTrue(FEmailValidator.isValid('abc_def@abc.com'), 'abc_def@abc.com');
  CheckFalse(FEmailValidator.isValid('abc@abc_def.com'), 'abc@abc_def.com');
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTEmailValidator.Suite);

end.
