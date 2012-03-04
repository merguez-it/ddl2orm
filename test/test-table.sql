CREATE TABLE molecule (
  moleculeId INTEGER NOT NULL,
  name TEXT NOT NULL,
  homeopathy BOOLEAN NOT NULL CHECK (homeopathy IN (0, 1)),
  mediaVidalIndex BOOLEAN NOT NULL CHECK (mediaVidalIndex IN (0, 1)),
  allergenicMoleculeId INTEGER,
  allergyAlert BOOLEAN NOT NULL CHECK (allergyAlert IN (0, 1)),
  role INTEGER NOT NULL CHECK (role IN (0, 1, 2)),
  useInComposition BOOLEAN NOT NULL CHECK (useInComposition IN (0, 1)),
  pharmacologypropertyId INT,
  pharmacologypropertycomment TEXT,
  PRIMARY KEY (moleculeId),
  FOREIGN KEY (allergenicMoleculeId) REFERENCES molecule(moleculeId)
);