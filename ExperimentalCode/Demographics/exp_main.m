function Results = GetDemographics(Results)

if nargin < 1
    Results = [];%
end
Results.Subject = input('Versuchspersonennummer?');
Results.Age = input('Alter?');
Results.Handedness = input('Links-(l) oder Rechtshänder(r)', 's');
Results.Sex = input('Geschlecht(m/f/d)?', 's');
Results.CorrectedVision = input('Brille(b), Kontaktlinsen(k) oder nichts(n)?', 's');


save (['./data/',num2str(Results.Subject)],'Results')
end

