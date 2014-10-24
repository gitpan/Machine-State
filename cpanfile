requires "Bubblegum" => "0.31";
requires "Exporter::Tiny" => "0.038";
requires "Function::Parameters" => "1.0401";
requires "Moose" => "2.1211";
requires "Throwable" => "0.200011";
requires "perl" => "v5.14.2";

on 'test' => sub {
  requires "perl" => "v5.14.2";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};
